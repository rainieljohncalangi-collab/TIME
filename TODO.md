# TestSync — W eb OMR Sheet + Automatic Score Sync + Section Folders

## Completed Steps

### 1. Web OMR Sheet (`testsync-omr-sheet.html`) ✅
- ✅ Connected to server: Quiz dropdown loaded from `/api/quizzes` — selecting a quiz auto-fills the item count so bubbles match the answer key
- ✅ Name and Section fields printed on the sheet
- ✅ **Student number removed** (per user request) — no "No." input, no NO.: on sheet, no number in QR, no number URL param, no unused CSS
- ✅ QR **auto-generates** when teacher types Name / Section or changes the Quiz. Payload: `{app, name, section, items, quizId, pageStart, pageItems, paper, academicYear, recordFileId}`
- ✅ QR positioned clear of the four corner anchors and the header divider line
- ✅ CDN qrcode library first, server `/api/qr` as fallback
- ✅ URL params pre-fill (`quizId`, `items`, `name`, `section`, `recordFileId`, `academicYear`)
- ✅ Layout modes (quarter / half-cross / half-length / whole) with per-mode master limits

### 2. Server (`server.js`) ✅
- ✅ `studentNumber` field kept in Score schema (optional, `default: ''`) — Android stays consistent
- ✅ `POST /api/scores` accepts `studentNumber`
- ✅ `GET /api/scores` already filters by `section`, `academicYear`, `recordFileId`, `quizId`
- ✅ Record-files endpoints exist (create + list) for the section/school-year folders

### 3. Android App (`studentNumber` end-to-end) ✅ — left intact
- ✅ `MainActivity.kt`, `ResultActivity.kt`, `ScanCheckApi.kt`, `ScoreEntity.kt`, `ResultsFragment.kt`, `ScoreAdapter.kt`, `activity_result.xml`, `item_score.xml` all keep `studentNumber` support

### 4. Students & Scores page (`students.html`) ✅
- ✅ **Removed the manual entry form** (Name/Score/Wrong/Item Analysis inputs + "Add Name & Score")
- ✅ Loads all scanned scores automatically from `GET /api/scores`
- ✅ Shows Name, Section, Score (score/totalItems), Quiz (via quiz title map), Date
- ✅ Auto-refreshes every 15s — scores appear on their own when the app does SYNC ALL
- ✅ Manual "↻ Refresh" button + quiz-title mapping + server error message

### 6. Answer Key Types: MC / T/F / Y/N ✅
- ✅ `server.js` — `quizSchema.answerKey` changed to `[Mixed]`; added `normalizeAnswerKey()` that accepts legacy numbers (MC) or `{ t, a }` objects and validates per-type (MC: 0-4, TF/YN: 0/1). Used by POST and PUT `/api/quizzes`.
- ✅ `quizzes.html` — each answer-key item now has a type dropdown (MC / T/F / Y/N). Choices update per type (A-E, T/F, Y/N). Save sends `{ t, a }` objects; edit renders them back via `normalizeQuizData()`.
- ✅ `testsync-omr-sheet.html` — when a quiz is selected, `answerKeyCounts()` maps the answer-key types to the MC / T/F / Y/N counters so printed bubbles match the answer key.

### 5. Home page / Dashboard (`dashboard.html`) ✅
- ✅ **Section folders by Section & School Year** — e.g. section "RAIN" + school year "12 CSS" → all its documents/scores go into the "12 CSS" folder
- ✅ Scores **auto-group** into folders from their `section` + `academicYear` even if no named file exists yet
- ✅ Ability to create record files (named container attached to a section + school year)
- ✅ Folders expand to show the student scores inside
- ✅ Auto-refreshes every 15s so new app syncs appear automatically
- ✅ Search bar filters folders by section, school year, file name, or student name

### 7. Fix: Answer Key selection disappearing in New Quiz modal ✅
- ✅ Root cause: `mcCountEl/tfCountEl/ynCountEl` `input` listeners passed the raw `Event` object as `seedData` into `renderAnswerKey()`, so `normalizeQuizData(seedData)` called `.map()` on a non-array and threw, hiding the answer-key bubbles.
- ✅ Fix (`quizzes.html`): wrapped the three listeners in arrow functions — `() => renderAnswerKey()` — so the Event is not passed. Answer-key selection bubbles (A-E / T/F / Y/N) now render again when counts are entered.

## Flow
1. Teacher creates a quiz in **Quizzes**.
2. Teacher prints the OMR sheet (Name + Section typed, auto-QR with quizId).
3. Student answers on paper; teacher scans with the **Android app**.
4. App detects the quiz from the QR and computes the score.
5. Teacher hits **SYNC ALL** in the app → each name + score is posted to the server.
6. The **Students & Scores** page and the **Dashboard section folders** update automatically (~15s).

