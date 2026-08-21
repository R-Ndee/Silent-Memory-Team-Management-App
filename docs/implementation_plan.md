# Silent Memory Team Management App — Complete Analysis

---

# 1. PROJECT UNDERSTANDING

Silent Memory Team Management App is an **internal team performance and payroll management application** for a photography team ("Silent Memory"). It replaces a manual spreadsheet-based system for tracking daily work, calculating compensation, and managing team operations.

**Core workflow:**
1. **Super Admin** creates user accounts (no self-registration).
2. **Admin** configures jobdesks (work definitions), creates assignments (linking members to jobdesks with rates/targets/deadlines), and manages crew photography activities.
3. **Members** log in daily and self-report which assigned jobs they completed, with optional notes.
4. The **system** automatically determines performance status (DONE / LATE / VERY_LATE / NOT_DONE) based on submission time vs. deadline.
5. The **system** calculates realization (count of completed work) and achievement (quality score weighted by timeliness).
6. **Admin** creates payroll periods, the system calculates payroll (realization × rate + crew compensation + bonuses − deductions), Admin reviews and approves.
7. **Members** can only see their payroll after approval.
8. All administrative changes are recorded in an **audit log**.

**Key business principles:**
- Historical data is immutable — current configuration changes must never overwrite past records
- Payroll is based on realization (actual work done), NOT achievement (timeliness score) in V1
- Achievement is an evaluation metric only, not a pay modifier
- Transparency: work already performed cannot be silently removed from payroll
- All times use WITA (Asia/Makassar, UTC+8)

**Tech stack:** Flutter + Riverpod + GoRouter + Firebase (Auth + Firestore)

**Target platform:** Android smartphone (mobile-first, portrait), with architecture extensible to iOS/web/desktop.

---

# 2. CURRENT PROJECT STATE

## What Exists

| Item | Status | Notes |
|---|---|---|
| Flutter project scaffold | ✅ | Flutter 3.44.9, Dart 3.12.2, stable channel |
| [pubspec.yaml](file:///home/r-ndee/Project/silent-memory-team-management-app/pubspec.yaml) | ✅ | Only `firebase_core: ^4.13.0` as business dependency |
| [lib/main.dart](file:///home/r-ndee/Project/silent-memory-team-management-app/lib/main.dart) | ✅ | Default "Hello World!" — no Firebase init, no Riverpod, no GoRouter |
| [lib/firebase_options.dart](file:///home/r-ndee/Project/silent-memory-team-management-app/lib/firebase_options.dart) | ✅ | FlutterFire CLI-generated, multi-platform, project `silent-memory` |
| [android/app/google-services.json](file:///home/r-ndee/Project/silent-memory-team-management-app/android/app/google-services.json) | ✅ | Matches `firebase_options.dart`, package `com.example.silent_memory_app` |
| Android Gradle (KTS) | ✅ | `google-services` plugin applied, Java 17, Kotlin 2.3.20 |
| [firebase.json](file:///home/r-ndee/Project/silent-memory-team-management-app/firebase.json) | ✅ | FlutterFire platform mappings |
| Documentation | ✅ | All 5 docs now populated (~120KB total) |
| Platform folders | ✅ | android, ios, linux, macos, web, windows |

## What Is Missing

| Item | Status |
|---|---|
| Firebase initialization in `main.dart` | ❌ `Firebase.initializeApp()` not called |
| `firebase_auth` dependency | ❌ |
| `cloud_firestore` dependency | ❌ |
| `flutter_riverpod` dependency | ❌ |
| `go_router` dependency | ❌ |
| Entire `lib/` architecture (`core/`, `models/`, `providers/`, `services/`, `screens/`, `widgets/`) | ❌ |
| Test directory and tests | ❌ |
| Assets directory | ❌ |
| Theme / design system | ❌ |
| Any business logic, models, screens, navigation | ❌ |

## Firebase Configuration Verification

- **Project ID:** `silent-memory` — consistent across `firebase.json`, `google-services.json`, and `firebase_options.dart` ✅
- **Android app ID:** matches across all config files ✅
- **google-services Gradle plugin:** applied in both `settings.gradle.kts` and `app/build.gradle.kts` ✅
- **`Firebase.initializeApp()`:** NOT called in `main.dart` — must be added during Phase 1
- **Dependencies present:** Only `firebase_core` — `firebase_auth` and `cloud_firestore` must be added

---

# 3. PRD UNDERSTANDING

## Roles and Permissions

### Super Admin
- Creates and disables user accounts (members do NOT self-register)
- Changes user roles
- Modifies approved/locked data (payroll periods, assignments, corrections)
- Accesses full audit log
- Has all Admin permissions plus emergency correction authority
- Used for critical/exceptional changes, NOT daily operations

### Admin
- Manages daily operations: assignments, jobdesks, targets, deadlines
- Monitors all members' performance in real-time
- Records crew photography activities
- Creates payroll periods, calculates payroll, adds manual bonuses/deductions
- Approves payroll
- Views audit log (with permission restrictions per SCHEMA.md §24)
- **Cannot:** create/delete accounts, change roles, modify locked data without Super Admin

### Member
- Logs in with provided credentials
- Views own assignments and jobdesk details
- Submits daily performance (today or backdated, NEVER future dates)
- Views own performance history, achievement, and realization
- Views own payroll ONLY after approval
- **Cannot:** see other members' data, modify assignments/targets/payroll, access audit log, edit submitted performance directly

## Assignment & Jobdesk System

**Jobdesk** = definition of work (e.g., "Up Story", "Editing Project") with default rate, target, deadline times, and late tolerance windows.

**Assignment** = links a Member to a Jobdesk for a date range, with a specific rate and target that are **snapshotted** at creation time (not live-linked to jobdesk defaults).

Assignments are NOT created day-by-day. Instead, a member has a standing assignment (e.g., "Up Story — 30/month") and Admin can mark specific days as NOT_ASSIGNED when needed.

## Performance Submission

1. Member opens performance input form (default date = today).
2. Member selects date (today or any past date; future dates rejected).
3. Member selects completed work from their active assignments.
4. Member adds optional note.
5. System records both `workDate` and `submittedAt` timestamp.
6. System computes status based on submission time vs. deadline:

| Condition | Status | Achievement Weight |
|---|---|---|
| Submitted before deadline | DONE | 1.00 |
| Submitted within `lateDurationMinutes` after deadline | LATE | 0.75 |
| Submitted within `veryLateDurationMinutes` after late | VERY_LATE | 0.50 |
| Not submitted beyond all tolerance | NOT_DONE | 0.00 |
| No assignment on this date | NOT_ASSIGNED | (excluded) |

**Backdated submission:** If `workDate = Aug 10` but `submittedAt = Aug 11 09:30`, the system records this transparently. The status calculation is based on the submission time relative to the work date's deadline.

## Achievement vs. Realization

- **Realization** = count of work actually submitted (regardless of timeliness)
- **Achievement** = weighted quality score: `Σ(achievementWeight) / totalAssignedDays`
- **In V1, payroll is based ONLY on realization, NOT achievement.** Achievement is an evaluation metric only.

## Assignment Changes After Submission

If a member has already submitted performance for a date and Admin later changes that date to NOT_ASSIGNED:
- The existing submission is **preserved** (not deleted)
- Historical performance records remain intact
- The work is still counted for payroll
- The change is logged in audit trail
- Admin cannot silently erase completed work

## Member Joining Mid-Period

If a member joins on day 15 of a 30-day payroll period:
- **Target is prorated** to their effective working days (15 out of 30)
- Achievement is calculated against the prorated target
- Payroll is based on actual work performed

## Crew Photography

- Additional work separate from regular assignments
- One member can be crew for multiple events on the same day (multiple records allowed)
- Has its own rate per activity
- Recorded by Admin
- Added to payroll as separate compensation line item

## Payroll

**Formula:** `Performance Amount + Crew Amount + Bonus − Deduction = Net Payroll`

**Performance Amount** = realization count × rate (from the assignment that was active when work was done).

**Lifecycle:** DRAFT → CALCULATED → APPROVED → LOCKED (per SCHEMA.md)
- PRD mentions DRAFT → REVIEW → APPROVED → COMPLETED (slight difference — see §4 below)
- Members see payroll ONLY after APPROVED status
- Locked payroll requires Super Admin for any changes

**Payroll period** is flexible (not necessarily calendar month), e.g., June 1 – July 15.

## Audit Log

Records all important administrative actions with: actor, role, action, target, timestamp, before/after values, optional reason. Immutable — cannot be edited by ordinary users.

---

# 4. DOCUMENT CONSISTENCY

## Identified Contradictions and Ambiguities

### 4.1 Payroll Lifecycle States — PRD vs. SCHEMA.md

| Document | States |
|---|---|
| [PRD.md §20](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/PRD.md#L575-L601) | DRAFT → REVIEW → APPROVED → COMPLETED |
| [SCHEMA.md §16](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/SCHEMA.md#L446-L453) (payroll_periods) | DRAFT → OPEN → CALCULATED → APPROVED → LOCKED |
| [SCHEMA.md §21](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/SCHEMA.md#L563-L593) (payrolls) | DRAFT → CALCULATED → APPROVED → LOCKED |
| [RULES.md §30](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/RULES.md#L585-L606) | Draft → Calculated → Review → Approved → Locked |

> [!IMPORTANT]
> **Contradiction:** The payroll lifecycle states differ across documents. PRD uses REVIEW/COMPLETED while SCHEMA.md uses OPEN/CALCULATED/LOCKED. RULES.md adds yet another variant. The SCHEMA.md definitions are the most detailed and should likely be authoritative per the priority order, but this must be confirmed.

**Recommendation:** Follow SCHEMA.md's definitions (DRAFT → OPEN → CALCULATED → APPROVED → LOCKED for `payroll_periods`, DRAFT → CALCULATED → APPROVED → LOCKED for `payrolls`) since SCHEMA.md is the data authority. PRD's REVIEW/COMPLETED appear to be conceptual descriptions of the same flow.

---

### 4.2 Audit Log Access — PRD vs. ARCHITECTURE vs. SCHEMA

| Document | Statement |
|---|---|
| [PRD.md §27](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/PRD.md#L748) | "Audit log hanya dapat diakses oleh Super Admin." |
| [ARCHITECTURE.md §6.2](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/ARCHITECTURE.md#L240) | Admin can "Melihat audit log sesuai permission." |
| [SCHEMA.md §24](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/SCHEMA.md#L637-L650) | Super Admin has full access; Admin can view "sesuai permission." |

> [!IMPORTANT]
> **Contradiction:** PRD states audit log is Super Admin-only. ARCHITECTURE.md and SCHEMA.md allow Admin partial access. Per the document priority order (PRD > ARCHITECTURE > SCHEMA), the strictest interpretation (Super Admin only) should apply — OR this ambiguity should be resolved before implementation.

---

### 4.3 Document Filename Reference Inconsistency

ARCHITECTURE.md §45 and SCHEMA.md §39 reference `docs/DATABASE_SCHEMA.md`, but the actual file is named `docs/SCHEMA.md`.

> [!NOTE]
> This is a minor naming inconsistency in internal references. Implementation should use the actual filename `SCHEMA.md`.

---

### 4.4 Payroll Period Status vs. Payroll Status

SCHEMA.md defines **two separate** status lifecycles:
- **payroll_periods:** DRAFT → OPEN → CALCULATED → APPROVED → LOCKED
- **payrolls** (per-member records): DRAFT → CALCULATED → APPROVED → LOCKED

This is logically sound — the period is a container and individual payrolls within it have their own lifecycle. However, the interaction between these two state machines is not explicitly documented (e.g., can individual payrolls be approved independently, or must the period be approved which then cascades?).

---

### 4.5 Performance Status: PRD vs. ARCHITECTURE

| Document | Statuses |
|---|---|
| [PRD.md §9](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/PRD.md#L229-L244) | NOT_ASSIGNED, ASSIGNED, COMPLETED, LATE, VERY_LATE, NOT_DONE |
| [ARCHITECTURE.md §13](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/ARCHITECTURE.md#L465-L500) | NOT_ASSIGNED, NOT_DONE, DONE, LATE, VERY_LATE |
| [SCHEMA.md §9](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/SCHEMA.md#L243-L272) | DONE, LATE, VERY_LATE, NOT_DONE, NOT_ASSIGNED |

> [!WARNING]
> **Contradiction:** PRD includes `ASSIGNED` (task is assigned but not yet completed) and `COMPLETED` (task done on time). ARCHITECTURE and SCHEMA use `DONE` instead of `COMPLETED` and do not include `ASSIGNED` as a stored status. Since ARCHITECTURE/SCHEMA are the implementation-level documents, `DONE` should be used instead of `COMPLETED`. `ASSIGNED` appears to be a UI-level state (assignment exists but no submission yet) rather than a stored performance status.

---

### 4.6 Crew Photography Input — PRD vs. ARCHITECTURE

[PRD.md §18](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/PRD.md#L514-L554) describes crew input appearing on the member's performance submission form ("Menjadi crew hari ini? Ya/Tidak"). ARCHITECTURE.md §25 describes it as an Admin-only input. Both documents agree that a separate Admin crew management feature also exists.

> [!NOTE]
> This is not strictly contradictory — the member can indicate crew participation on their daily form, while Admin has a dedicated crew management section for recording details (multiple events, compensation). Implementation should support both entry points.

---

### 4.7 "Login" in Audit Log

[PRD.md §27](file:///home/r-ndee/Project/silent-memory-team-management-app/docs/PRD.md#L722) lists "Login" as an auditable action. Neither ARCHITECTURE.md §27 nor SCHEMA.md §25 includes LOGIN in their audit action lists. This is a minor discrepancy — logging all logins could generate high volume.

---

## Consistent Across All Documents

- Three roles: Member, Admin, Super Admin ✅
- Firebase Auth + Firestore ✅
- Riverpod + GoRouter ✅
- Historical data immutability principle ✅
- Rate snapshotted in assignment (not live-linked to jobdesk) ✅
- Timezone WITA (UTC+8) ✅
- No attendance system ✅
- No self-registration ✅
- Payroll = realization-based, achievement is evaluation-only ✅
- Member can't see payroll before approval ✅
- No future date performance submission ✅
- Soft-delete (status = inactive) instead of hard delete ✅

---

# 5. DATABASE / SCHEMA ASSESSMENT

## Collections

SCHEMA.md defines 8 collections: `users`, `jobdesks`, `assignments`, `performances`, `crew_activities`, `payroll_periods`, `payrolls`, `audit_logs`.

## Historical Integrity Assessment

### Assignment Transfer Scenario
> Employee A performs Video Editor for 10 days → Admin transfers to Employee B on day 11.

**Schema support:** ✅ Fully supported.
- Assignment A: memberId=A, jobdeskId=VideoEditor, startDate=Jun1, endDate=Jun10, rate=20000
- Assignment B: memberId=B, jobdeskId=VideoEditor, startDate=Jun11, endDate=null, rate=20000
- Performance records for Jun 1–10 store `assignmentId` pointing to Assignment A
- Rate is stored ON the assignment, not looked up from jobdesk
- Changing assignment does not retroactively alter performance records

### Rate Change Scenario
> Jobdesk rate changes from 20,000 → 25,000 on day 11.

**Schema support:** ✅ Fully supported.
- Assignment stores its own `rate` field (snapshotted at creation)
- Old assignment keeps rate=20000
- New assignment uses rate=25000
- Historical payroll uses the assignment rate, not the current jobdesk default

### Assignment Changed After Submission
> Member submits for day X, then Admin marks day X as NOT_ASSIGNED.

**Schema support:** ✅ The performance record retains `assignmentId`, `jobdeskId`, `workDate`, `submittedAt`, `status`, and `achievementWeight`. The record is not deleted. Audit log captures the assignment change.

### Target Changes
**Schema support:** ⚠️ Partially supported.
- Assignments store a `target` field, so the current target is known.
- However, there is no explicit `assignment_target_history` collection or sub-collection.
- PRD §15 requires: "Sistem harus menyimpan histori perubahan target."
- When an assignment's target changes, the audit log WOULD capture before/after data (if implementation logs beforeData/afterData).
- This means target history is reconstructable from audit logs, but not from a dedicated history table.

> [!NOTE]
> This is acceptable for V1 — audit logs contain before/after snapshots. If target history queries become frequent, a dedicated history mechanism could be added later.

### Member Joining Mid-Period
**Schema support:** ✅
- `users.joinedAt` provides the start date for eligibility.
- Prorated target calculation is a business logic concern, not a schema concern.
- The schema provides all necessary dates to compute effective working days.

### Payroll Snapshot
**Schema support:** ✅
- `payrolls` collection stores calculated amounts (`totalPerformanceAmount`, `totalCrewAmount`, `bonusAmount`, `deductionAmount`, `grossAmount`, `netAmount`).
- Once approved/locked, these amounts are fixed regardless of subsequent rate/assignment changes.

## Missing Schema Elements

### Manual Payroll Adjustments Storage
- SCHEMA.md §22 mentions manual adjustments (bonus/deduction) must store amount, reason, createdBy, createdAt.
- The `payrolls` collection has `bonusAmount` and `deductionAmount` as aggregate numbers.
- PRD §32 lists `payroll_adjustments` as a separate entity.
- **SCHEMA.md does NOT define a `payroll_adjustments` collection.**

> [!WARNING]
> PRD §32 explicitly lists `payroll_adjustments` as a planned entity, but SCHEMA.md doesn't define its structure. Individual adjustments need their own records (with reason, actor, timestamp) rather than just aggregate amounts on the payroll record. This is a gap that should be addressed — either as a sub-collection of payrolls or a separate top-level collection.

### Performance `correctionStatus` / `correctedBy`
SCHEMA.md §8 includes `correctionStatus`, `correctedAt`, `correctedBy` fields on performances — this supports the correction workflow well ✅.

### Duplicate Prevention
SCHEMA.md §34 defines logical uniqueness: `memberId + assignmentId + workDate` for performances, and `payrollPeriodId + memberId` for payrolls. This must be enforced in service layer and/or security rules ✅.

## Overall Schema Verdict

The schema is **well-designed for historical integrity**. The key design decisions (rate on assignment, assignmentId on performance, separate performance and assignment lifecycle) are sound. The main gap is the undefined `payroll_adjustments` structure.

---

# 6. ARCHITECTURE ASSESSMENT

## Appropriateness

The architecture (UI → Riverpod → Services → Firebase) is **appropriate** for this application scale. ARCHITECTURE.md §3 explicitly rejects over-complex Clean Architecture patterns (Domain/Data/Repository/UseCase/Entity/DTO/Mapper) in favor of a simpler three-layer model. This is a good fit for a small-medium team management app.

## Folder Structure

The defined structure is clear and follows a reasonable pattern:

```
lib/
├── core/ (constants, theme, utils, routing)
├── models/
├── providers/
├── services/
├── screens/ (auth, member, admin, super_admin)
├── widgets/
└── main.dart
```

This is a standard Flutter project structure. Feature-based grouping is allowed for large features, which provides growth flexibility.

## Riverpod Usage

Provider responsibilities are well-defined (§8): separate providers for auth, user, role, assignment, jobdesk, performance, crew, payroll, dashboard, audit. The requirement to keep providers focused (not one giant provider) is sound.

## GoRouter Usage

Route structure (§7) follows role-based grouping (`/member/*`, `/admin/*`, `/super-admin/*`) with route protection based on auth state and role. This is clean and enforceable.

## Service Layer

Services handle Firebase operations and business logic. The separation (Widget = UI, Provider = state, Service = business operations + Firebase) is appropriate and matches RULES.md requirements.

## Risks and Concerns

### 6.1 Riverpod Generation vs Manual
ARCHITECTURE.md does not specify whether to use `riverpod_annotation` / `riverpod_generator` (code-gen approach) or manual provider definitions. Either approach works, but the choice affects boilerplate and developer experience.

> [!NOTE]
> Since ARCHITECTURE.md says "Jangan menggunakan Clean Architecture yang terlalu kompleks" and values simplicity, manual Riverpod providers (without code generation) would be most consistent with the documented philosophy.

### 6.2 Firebase Account Creation
ARCHITECTURE.md §5 and PRD §6 require Super Admin to create accounts via Firebase Authentication. The standard Firebase Auth client SDK **cannot create accounts on behalf of other users** without signing out the current user. This typically requires either:
- Firebase Admin SDK (backend/Cloud Functions)
- Creating accounts via the client SDK with a workaround (create → sign out → sign back in)

> [!WARNING]
> **This is a significant implementation concern.** The documentation does not specify which approach to use. The simplest V1 approach is the client-side workaround (create account with secondary Firebase App instance), but this has limitations. Cloud Functions would be more robust but adds infrastructure complexity.

### 6.3 Deadline/Late Calculation Timezone Handling
Deadline logic requires comparing `submittedAt` against deadline times in WITA. Firestore Timestamps are UTC-based. The service layer must correctly convert between UTC and WITA (UTC+8) for all business date comparisons. This is doable but error-prone and must be carefully implemented.

### 6.4 Dashboard Aggregation
ARCHITECTURE.md §26 says dashboards should compute statistics from source data (not stored aggregates). For small-medium data volumes, this is fine. If data grows large, queries across all performances/assignments for dashboard could become slow. The doc acknowledges cached/summary data can be added later — acceptable for V1.

---

# 7. SECURITY / PERMISSION ASSESSMENT

## Role-Based Access

The security model is clearly defined across all three documents:

| Operation | Member | Admin | Super Admin |
|---|---|---|---|
| Login | ✅ | ✅ | ✅ |
| View own data | ✅ | ✅ | ✅ |
| View all members' performance | ❌ | ✅ | ✅ |
| Submit own performance | ✅ | ❌ | ❌ |
| Manage assignments | ❌ | ✅ | ✅ |
| Manage jobdesks | ❌ | ✅ | ✅ |
| Record crew activities | ❌ | ✅ | ✅ |
| Create/approve payroll | ❌ | ✅ | ✅ |
| View payroll (before approval) | ❌ | ✅ | ✅ |
| View own payroll (after approval) | ✅ | ✅ | ✅ |
| View other members' payroll | ❌ | ✅ | ✅ |
| Create/disable accounts | ❌ | ❌ | ✅ |
| Change roles | ❌ | ❌ | ✅ |
| Modify locked/approved data | ❌ | ❌ | ✅ |
| View audit log | ❌ | ⚠️ | ✅ |
| Emergency correction | ❌ | ❌ | ✅ |

## Two-Layer Security

All documents consistently emphasize:
1. **Application level (Flutter):** UI restrictions for UX — NOT security
2. **Firebase Security Rules:** The actual enforcement boundary

RULES.md §62 explicitly states: "Menyembunyikan button bukan security."

## Security Gaps / Concerns

### 7.1 Firebase Auth Account Creation (reiterated)
Creating Firebase Auth accounts from the client side is architecturally problematic. Without Cloud Functions or Admin SDK, the Super Admin client would need to use `createUserWithEmailAndPassword`, which signs out the current user. This needs a clear implementation strategy.

### 7.2 Role Storage and Verification
Role is stored in Firestore `users` collection. Firebase Security Rules must read this role to authorize operations. This is standard but requires careful Security Rules implementation — the role in Firestore must be the authority, not the client-reported role.

### 7.3 Future Date Prevention
RULES.md §20 mentions server-side time validation: "Tanggal harus divalidasi menggunakan server/backend-authoritative time jika diperlukan." Firestore Security Rules can use `request.time` for server-timestamp validation, but preventing future `workDate` requires comparing against server time in rules — this is implementable.

### 7.4 Performance Duplicate Prevention
Security Rules should prevent duplicate `memberId + assignmentId + workDate` combinations. This is harder to enforce purely in Security Rules and may need service-layer validation with Firestore transactions.

## Overall Security Assessment

The security model is **well-defined and sufficient** for the application requirements. The main implementation challenge is the Firebase Security Rules complexity, particularly around role verification, future date prevention, and the account creation mechanism.

---

# 8. DESIGN ASSESSMENT

## Clarity and Implementability

DESIGN.md is **exceptionally detailed and implementable.** It provides:

- ✅ Clear design philosophy (professional, clean, calm — explicitly anti-AI-dashboard)
- ✅ Typography system (Inter font, defined weight hierarchy)
- ✅ Spacing system (4px base, consistent multiples)
- ✅ Color role definitions (semantic tokens, not specific hex values)
- ✅ Shape system (corner radius by component type)
- ✅ Elevation rules (minimal shadows, prefer borders)
- ✅ Component guidelines (buttons, cards, lists, forms, badges)
- ✅ Status color semantics (DONE=success, LATE=warning, etc.)
- ✅ Navigation (bottom nav, app bar rules)
- ✅ Empty/loading/error state requirements
- ✅ Confirmation dialog requirements for destructive actions
- ✅ Anti-patterns explicitly listed (no glassmorphism, no excessive gradients, no giant stat cards)
- ✅ Screen composition checklist
- ✅ Accessibility requirements
- ✅ Design token centralization requirement

## Items Not Specified

- **Specific hex color values:** DESIGN.md defines semantic roles but not exact colors. This gives implementation flexibility but requires design decisions during implementation.
- **Specific font sizes:** Typography hierarchy is described by weight ranges but not exact pixel sizes.
- **Dark mode:** Not mentioned — V1 appears to be light mode only (unspecified).
- **App icon design:** Not specified.
- **Splash screen:** Not specified.

## Flutter Implementability

All design requirements are **fully implementable in Flutter**:
- Inter font → `google_fonts` package or bundled asset
- Semantic color tokens → Flutter `ThemeData` + `ColorScheme` + custom extension
- Spacing system → Constants class
- Component library → Reusable widget files in `widgets/`
- Bottom navigation → `NavigationBar` or `BottomNavigationBar`
- Responsive smartphone layouts → `MediaQuery`, `LayoutBuilder`, `SafeArea`

---

# 9. DEPENDENCIES

## Currently Present

| Package | Version | Status |
|---|---|---|
| `firebase_core` | ^4.13.0 | ✅ Required for Firebase initialization |
| `flutter` (SDK) | — | ✅ Framework |
| `flutter_lints` (dev) | ^6.0.0 | ✅ Lint rules |
| `flutter_test` (dev) | SDK | ✅ Testing |

## Required by Documentation

| Package | Why Required |
|---|---|
| **`firebase_auth`** | Firebase Authentication — required by ARCHITECTURE §5, PRD §6 |
| **`cloud_firestore`** | Firestore database — required by ARCHITECTURE §2, SCHEMA throughout |
| **`flutter_riverpod`** | State management — required by ARCHITECTURE §8, RULES §10 |
| **`go_router`** | Navigation/routing — required by ARCHITECTURE §7, RULES §12 |
| **`google_fonts`** | Inter font family — required by DESIGN §7 |
| **`intl`** | Date/time formatting, number/currency formatting (Indonesian Rupiah) — needed for payroll display, date formatting throughout |

## Potentially Required

| Package | Reason | Assessment |
|---|---|---|
| `freezed` + `freezed_annotation` + `json_annotation` + `build_runner` | Immutable model generation with Firestore serialization | Not mandated — ARCHITECTURE says models need `fromFirestore()`/`toFirestore()` which can be hand-written. Could be useful but RULES §73 warns against overengineering |
| `riverpod_annotation` + `riverpod_generator` | Code-gen Riverpod providers | Not mandated — manual providers are simpler and more consistent with ARCHITECTURE's simplicity principle |
| `connectivity_plus` | Network state detection for offline feedback | DESIGN §44 and ARCHITECTURE §36 require network state feedback, but basic Firebase error handling may suffice for V1 |
| `uuid` | Generate unique IDs for Firestore documents | Firestore auto-generates document IDs; may not be needed |

## Not Needed

- `shared_preferences` / `hive` — ARCHITECTURE §2 explicitly says no local database for business data
- `bloc` / `provider` — Riverpod is the mandated state management
- `auto_route` — GoRouter is mandated
- `dio` / `http` — No REST API; Firestore SDK handles communication

---

# 10. IMPLEMENTATION RISKS

| Level | Risk | Details |
|---|---|---|
| 🔴 **CRITICAL** | **Firebase account creation from client** | Super Admin must create accounts for members. Firebase Auth client SDK's `createUserWithEmailAndPassword` signs out the current user. Implementation must use either a secondary Firebase App instance or Firebase Admin SDK/Cloud Functions. This is a non-trivial architectural decision that affects the auth flow. |
| 🔴 **CRITICAL** | **Timezone correctness** | ALL business logic (deadlines, late calculation, performance status, payroll period boundaries) depends on WITA (UTC+8). Firestore stores UTC timestamps. Every date comparison must correctly handle the timezone offset. A single timezone bug could cause incorrect LATE/DONE status calculations affecting payroll. |
| 🟡 **HIGH** | **Payroll calculation correctness** | Payroll uses historical rates from assignments (not current jobdesk rates). The service must look up the assignment that was active for each performance record and use THAT assignment's rate. Wrong rate lookups = wrong pay. |
| 🟡 **HIGH** | **Historical data integrity during assignment changes** | When Admin changes assignments, existing performance records must NOT be modified. Service layer must never cascade-update historical performance when an assignment is changed/ended. |
| 🟡 **HIGH** | **Payroll period ↔ payroll state machine interaction** | The relationship between `payroll_periods` status and individual `payrolls` status is not explicitly documented. Must be carefully designed to prevent inconsistent states (e.g., a payroll approved while its period is still in DRAFT). |
| 🟡 **HIGH** | **Duplicate performance prevention** | Unique constraint `memberId + assignmentId + workDate` must be enforced. Firestore has no native unique constraint — must use transactions or compound document IDs in the service layer. |
| 🟠 **MEDIUM** | **Prorated target calculation** | When a member joins mid-period, target must be prorated. The exact proration formula (calendar days? working days? based on assignment days?) is not precisely specified. Most consistent interpretation: based on the ratio of actual eligible days to total period days. |
| 🟠 **MEDIUM** | **Payroll adjustments storage** | PRD lists `payroll_adjustments` as an entity but SCHEMA.md doesn't define its structure. Need to decide: sub-collection under payrolls or top-level collection. |
| 🟠 **MEDIUM** | **Concurrency / race conditions** | Two admins modifying the same assignment or processing the same payroll simultaneously. Firestore transactions should be used for critical operations. |
| 🟠 **MEDIUM** | **Deadline calculation edge cases** | Deadline logic crosses midnight (work period 08:00–23:59, late 00:00–00:59, very late 01:00–04:59). This means "late" is actually the *next calendar day*. Must correctly handle the day boundary in WITA. |
| 🟢 **LOW** | **Dashboard performance** | Computing aggregations from raw data on every dashboard load could be slow with large datasets. Acceptable for V1 per ARCHITECTURE.md, with cached summaries possible later. |
| 🟢 **LOW** | **Package name (`com.example.silent_memory_app`)** | Should be changed for production but fine for development. |

---

# 11. RECOMMENDED IMPLEMENTATION ORDER

Based on ARCHITECTURE.md §44 development priority, RULES.md §71 implementation order, and dependency analysis:

## Phase 1 — Project Foundation
1. Add dependencies to `pubspec.yaml` (firebase_auth, cloud_firestore, flutter_riverpod, go_router, google_fonts, intl)
2. Initialize Firebase in `main.dart` with `WidgetsFlutterBinding.ensureInitialized()` + `Firebase.initializeApp()`
3. Create folder structure: `core/`, `models/`, `providers/`, `services/`, `screens/`, `widgets/`
4. Set up theme/design system in `core/theme/` (color tokens, typography, spacing, shape)
5. Set up constants in `core/constants/`
6. Wrap app in `ProviderScope` (Riverpod)
7. Set up GoRouter skeleton in `core/routing/`
8. Create reusable base widgets (AppButton, StatusBadge, LoadingState, ErrorState, EmptyState)

## Phase 2 — Authentication & Role System
1. Create `UserModel` with `fromFirestore()`/`toFirestore()`
2. Create `AuthService` (login, logout, get current user)
3. Create auth-related providers (authProvider, currentUserProvider, userRoleProvider)
4. Create login screen
5. Set up GoRouter redirect based on auth state + role
6. Create role-based shell routes (/member/*, /admin/*, /super-admin/*)
7. Handle loading/error states for auth

## Phase 3 — Master Data (Jobdesk & Assignment)
1. Create `JobdeskModel`, `AssignmentModel`
2. Create `JobdeskService`, `AssignmentService`
3. Create jobdesk/assignment providers
4. Create Admin screens: Jobdesk Management, Assignment Management
5. Implement assignment creation with rate/target snapshotting
6. Implement NOT_ASSIGNED day marking
7. Create Member screens: My Assignments view

## Phase 4 — Daily Performance
1. Create `PerformanceModel`
2. Create `PerformanceService` with status calculation logic (DONE/LATE/VERY_LATE/NOT_DONE)
3. Create `PerformanceStatusCalculator` utility with timezone-aware deadline logic
4. Create `AchievementCalculator` utility
5. Create performance providers
6. Create Member performance submission screen (with date picker, future date prevention)
7. Create Member performance history screen
8. Create Admin performance monitoring screen
9. Implement duplicate submission prevention
10. Handle backdated submission recording

## Phase 5 — Crew Photography
1. Create `CrewActivityModel`
2. Create `CrewService`
3. Create crew providers
4. Create Admin crew activity management screen
5. Add crew indicator to member daily submission form
6. Implement multiple crew records per day per member

## Phase 6 — Payroll
1. Create `PayrollPeriodModel`, `PayrollModel`
2. Create `PayrollService` with `PayrollCalculator`
3. Create payroll providers
4. Admin: Create payroll period screen
5. Admin: Payroll calculation (aggregate performance × assignment rate + crew compensation)
6. Admin: Manual bonus/deduction entry
7. Admin: Payroll review and approval workflow
8. Member: Payroll visibility (only after APPROVED status)
9. Implement payroll locking
10. Handle prorated targets for mid-period joiners

## Phase 7 — User Management & Audit
1. Create `AuditLogModel`, `AuditLogService`
2. Integrate audit logging into all administrative services (assignment changes, payroll, account management, etc.)
3. Super Admin: User management screen (create account, disable account, change role)
4. Super Admin: Audit log viewer
5. Super Admin: Emergency correction mechanism
6. Implement account creation (resolve Firebase Auth client-side creation challenge)

## Phase 8 — Dashboards, Polish & Testing
1. Member dashboard (today's tasks, submission status, achievement summary)
2. Admin dashboard (real-time operational overview)
3. Super Admin dashboard (system-wide view)
4. Performance reports screen (Admin)
5. Comprehensive error/loading/empty state handling across all screens
6. Confirmation dialogs for destructive actions
7. Unit tests for business logic (PayrollCalculator, PerformanceStatusCalculator, AchievementCalculator)
8. Widget tests for critical flows
9. Security review: verify route guards, role checks, data isolation
10. UI review against DESIGN.md checklist (§52)
11. Firebase Security Rules implementation and testing

---

# 12. QUESTIONS / BLOCKERS

### Q1: How should Super Admin create Firebase Auth accounts?

Firebase Auth client SDK's `createUserWithEmailAndPassword()` signs out the currently logged-in user. Options:
- **A:** Use a secondary Firebase App instance to create accounts without signing out
- **B:** Use Firebase Cloud Functions (requires server-side infrastructure)
- **C:** Use REST API call to Firebase Auth REST endpoint

This is a **blocking architectural question** that affects Phase 7. However, it does not block Phases 1–6.

### Q2: Should Admin have partial audit log access?

PRD says Super Admin only. ARCHITECTURE and SCHEMA say Admin can view "sesuai permission." Which is correct?

### Q3: `payroll_adjustments` collection — should it be created?

PRD §32 lists it as a planned entity. SCHEMA.md doesn't define it. Should adjustments be:
- **A:** Stored as a sub-collection under `payrolls/{payrollId}/adjustments/{adjustmentId}`
- **B:** A top-level `payroll_adjustments` collection
- **C:** Just stored as aggregate amounts on the `payrolls` document (current SCHEMA.md approach)

Option C loses individual adjustment detail (which adjustments, by whom, with what reason).

### Q4: Exact color values for the design system?

DESIGN.md defines semantic color roles but no specific hex values. Should implementation choose appropriate colors that fit the "professional, calm, clean" direction?

### Q5: Should Login be audited?

PRD lists it; ARCHITECTURE/SCHEMA do not. High-volume logging concern.

---

# 13. FINAL READINESS

## ✅ READY TO IMPLEMENT

All five documentation files are now populated and provide sufficient guidance for implementation. The identified contradictions (§4) are **minor** and can be resolved with reasonable interpretation:

1. **Payroll lifecycle states:** Follow SCHEMA.md definitions (most detailed/authoritative for data)
2. **Audit log access:** Follow PRD (Super Admin only) as conservative default, or ask user to confirm
3. **Performance status names:** Use DONE (not COMPLETED) per ARCHITECTURE/SCHEMA
4. **File naming:** Use actual filename `SCHEMA.md`

The **open questions** (§12) are important but **non-blocking for initial phases**:
- Q1 (account creation) only blocks Phase 7
- Q2–Q5 can be resolved during implementation with conservative defaults

The project has:
- ✅ Complete PRD with clear business rules
- ✅ Well-defined architecture with appropriate simplicity
- ✅ Thorough database schema with strong historical integrity
- ✅ Detailed design system with clear anti-patterns
- ✅ Comprehensive implementation rules and constraints
- ✅ Working Flutter project scaffold with Firebase configured
- ✅ Clear development phasing in documentation

**Implementation can begin with Phase 1 (Project Foundation) immediately.**
