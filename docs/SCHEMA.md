# DATABASE_SCHEMA.md

## 1. Database Overview

Database menggunakan Cloud Firestore.

Firestore menjadi source of truth untuk seluruh data bisnis aplikasi.

Database harus mempertahankan historical integrity.

Perubahan data saat ini tidak boleh secara otomatis mengubah data historis yang sudah digunakan untuk performance atau payroll.

Prinsip utama:

> Current configuration must not overwrite historical facts.

---

## 2. Firestore Collections

Struktur utama:

- users
- jobdesks
- assignments
- performances
- crew_activities
- payroll_periods
- payrolls
- audit_logs

Collection tambahan hanya boleh dibuat jika memang diperlukan oleh business logic.

Jangan membuat collection tambahan tanpa alasan yang jelas.

---

## 3. users

Collection: `/users/{userId}`

Digunakan untuk menyimpan profile, role, dan status user.

Firebase Authentication tetap menjadi sumber autentikasi.

Firestore hanya menyimpan informasi profile dan authorization-related data.

### Fields

- userId: String
- email: String
- displayName: String
- role: String
- status: String
- joinedAt: Timestamp
- inactiveAt: Timestamp | null
- createdAt: Timestamp
- updatedAt: Timestamp
- createdBy: String
- updatedBy: String

### Role

- member
- admin
- super_admin

### Status

- active
- inactive

User tidak boleh dihapus secara permanen jika sudah memiliki historical data.

Jika member berhenti bekerja, gunakan:

`status = inactive`

Historical performance dan payroll tetap tersedia.

---

## 4. jobdesks

Collection: `/jobdesks/{jobdeskId}`

Jobdesk adalah definisi pekerjaan.

Jobdesk bukan representasi siapa yang mengerjakan pekerjaan tersebut.

### Fields

- jobdeskId: String
- name: String
- code: String
- description: String | null
- category: String | null
- defaultRate: Number
- defaultTarget: Number
- deadlineStart: String
- deadlineEnd: String
- lateDurationMinutes: Number
- veryLateDurationMinutes: Number
- status: String
- createdAt: Timestamp
- updatedAt: Timestamp
- createdBy: String
- updatedBy: String

### Status

- active
- inactive

Jobdesk yang sudah pernah digunakan tidak boleh dihapus secara permanen.

Jika tidak digunakan lagi:

`status = inactive`

---

## 5. assignments

Collection: `/assignments/{assignmentId}`

Assignment merupakan hubungan antara:

- Member
- Jobdesk
- Periode berlaku
- Rate yang berlaku

Assignment digunakan untuk menentukan siapa yang bertanggung jawab terhadap jobdesk tertentu pada periode tertentu.

### Fields

- assignmentId: String
- memberId: String
- jobdeskId: String
- rate: Number
- target: Number
- startDate: Timestamp
- endDate: Timestamp | null
- status: String
- createdAt: Timestamp
- updatedAt: Timestamp
- createdBy: String
- updatedBy: String

### Status

- active
- ended
- cancelled

---

## 6. Assignment Historical Rule

Assignment harus mempertahankan histori.

Contoh:

Assignment A:
- Member A
- Video Editor
- 01 Jun - 10 Jun
- Rate = 20.000

Assignment B:
- Member B
- Video Editor
- 11 Jun - sekarang
- Rate = 20.000

Performance tanggal 1–10 Juni harus tetap mengarah ke Assignment A.

Performance tanggal 11 Juni dan seterusnya mengarah ke Assignment B.

Assignment baru tidak boleh mengubah historical performance.

---

## 7. Assignment Rate Snapshot

Rate disimpan langsung di assignment.

Jangan hanya mengambil rate dari jobdesk saat ini.

Contoh:

Jobdesk:
Video Editor

Assignment lama:
Rate = 20.000

Jobdesk saat ini:
defaultRate = 25.000

Assignment lama tetap menggunakan:

`rate = 20.000`

Assignment baru dapat menggunakan:

`rate = 25.000`

Dengan demikian perubahan rate tidak mengubah payroll historis.

---

## 8. performances

Collection: `/performances/{performanceId}`

Performance merupakan catatan pekerjaan yang dibuat oleh member.

Member melakukan submission sendiri.

Admin tidak menginput performance harian satu per satu.

### Fields

- performanceId: String
- memberId: String
- assignmentId: String | null
- jobdeskId: String | null
- workDate: Timestamp
- submittedAt: Timestamp
- status: String
- achievementWeight: Number
- note: String | null
- createdAt: Timestamp
- updatedAt: Timestamp
- correctionStatus: String
- correctedAt: Timestamp | null
- correctedBy: String | null

---

## 9. Performance Status

Status performance:

- DONE
- LATE
- VERY_LATE
- NOT_DONE
- NOT_ASSIGNED

### DONE

Member melakukan submission sebelum atau tepat pada deadline.

### LATE

Member melakukan submission setelah deadline tetapi masih dalam batas late.

### VERY_LATE

Member melakukan submission setelah batas late tetapi masih dalam batas very late.

### NOT_DONE

Member memiliki assignment tetapi tidak melakukan submission sampai melewati batas yang ditentukan.

### NOT_ASSIGNED

Member tidak memiliki tugas pada tanggal tersebut.

---

## 10. Achievement Weight

Achievement weight disimpan pada performance.

Default:

- DONE = 1.00
- LATE = 0.75
- VERY_LATE = 0.50
- NOT_DONE = 0.00
- NOT_ASSIGNED = tidak dihitung

Menyimpan nilai achievement pada performance membantu menjaga historical consistency.

Jika formula achievement berubah di masa depan, performance lama tidak boleh berubah secara diam-diam.

---

## 11. Performance Submission Rules

Member:

- Dapat input untuk hari ini.
- Dapat input untuk tanggal sebelumnya.
- Tidak dapat input untuk tanggal masa depan.

Tanggal default adalah hari ini.

Timezone:

- Asia/Makassar
- UTC+08:00
- WITA

Member dapat memilih tanggal sebelumnya untuk memperbaiki input yang terlambat.

Contoh:

Hari ini: 12 Agustus

Member belum mengisi 11 Agustus.

Member memilih:

`workDate = 11 Agustus`

Kemudian:

`submittedAt = 12 Agustus`

Sistem mengetahui bahwa submission dilakukan terlambat karena `submittedAt` berbeda dari `workDate`.

---

## 12. Performance Editing

Member tidak dapat mengubah performance yang sudah disubmit secara bebas.

Jika terdapat kesalahan:

Member
→ Meminta koreksi
→ Admin melakukan verifikasi
→ Admin/Super Admin melakukan correction
→ Audit log dibuat

Jika data sudah dikunci atau correction bersifat sensitif, Super Admin diperlukan.

---

## 13. Assignment Changed After Performance Submission

Kasus:

Member sudah submit performance.

Kemudian Admin mengubah assignment menjadi NOT_ASSIGNED.

Performance sebelumnya tidak boleh dihapus.

Performance tetap menyimpan:

- memberId
- assignmentId
- jobdeskId
- workDate
- submittedAt
- status
- achievementWeight

Data awal harus tetap dapat diketahui.

Jika perubahan assignment menyebabkan perubahan terhadap status atau perhitungan, perubahan tersebut harus tercatat dan dapat diaudit.

Pekerjaan yang benar-benar sudah dilakukan tidak boleh secara diam-diam dihilangkan dari historical payroll.

---

## 14. crew_activities

Collection: `/crew_activities/{crewActivityId}`

Digunakan untuk mencatat aktivitas member sebagai crew photography.

Crew dicatat oleh Admin.

### Fields

- crewActivityId: String
- memberId: String
- eventName: String
- workDate: Timestamp
- rate: Number
- status: String
- note: String | null
- createdAt: Timestamp
- updatedAt: Timestamp
- createdBy: String
- updatedBy: String

### Status

- active
- cancelled

---

## 15. Multiple Crew Activities Per Day

Satu member dapat menjadi crew untuk beberapa event pada hari yang sama.

Contoh:

12 Agustus:

Randi
- Event A
- Rate = 50.000

Randi
- Event B
- Rate = 50.000

Maka dibuat dua document crew activity.

Jangan membatasi satu member hanya memiliki satu crew activity per hari.

---

## 16. payroll_periods

Collection: `/payroll_periods/{payrollPeriodId}`

Payroll period menentukan rentang tanggal yang digunakan untuk menghitung payroll.

### Fields

- payrollPeriodId: String
- name: String
- startDate: Timestamp
- endDate: Timestamp
- status: String
- createdAt: Timestamp
- updatedAt: Timestamp
- createdBy: String
- updatedBy: String
- approvedAt: Timestamp | null
- approvedBy: String | null
- lockedAt: Timestamp | null
- lockedBy: String | null

### Status

- DRAFT
- OPEN
- CALCULATED
- APPROVED
- LOCKED

---

## 17. Payroll Period Rules

Payroll period dapat memiliki rentang tanggal fleksibel.

Contoh:

01 Jun → 15 Jul

Sistem menghitung data dari 01 Jun sampai 15 Jul.

Super Admin dapat melakukan perubahan terhadap payroll period jika diperlukan.

Perubahan terhadap payroll period yang sudah diproses harus dicatat di audit log.

---

## 18. payrolls

Collection: `/payrolls/{payrollId}`

Payroll menyimpan hasil perhitungan pembayaran untuk satu member dalam satu payroll period.

### Fields

- payrollId: String
- payrollPeriodId: String
- memberId: String
- totalPerformanceCount: Number
- totalPerformanceAmount: Number
- totalCrewCount: Number
- totalCrewAmount: Number
- bonusAmount: Number
- deductionAmount: Number
- grossAmount: Number
- netAmount: Number
- achievementPercentage: Number
- status: String
- calculatedAt: Timestamp | null
- approvedAt: Timestamp | null
- approvedBy: String | null
- lockedAt: Timestamp | null
- lockedBy: String | null
- createdAt: Timestamp
- updatedAt: Timestamp

---

## 19. Payroll Calculation

Payroll utama dihitung berdasarkan realisasi.

Formula dasar:

Performance Amount
+
Crew Amount
+
Bonus
-
Manual Deduction
=
Net Payroll

Performance amount menggunakan rate yang berlaku pada assignment saat pekerjaan tersebut dilakukan.

Achievement tidak mengurangi payroll pada V1.

Contoh:

10 pekerjaan dibuat.
Rate = Rp20.000.

Performance Amount:

10 × Rp20.000 = Rp200.000

Jika terdapat 2 crew activity dengan rate Rp50.000:

Crew Amount:

2 × Rp50.000 = Rp100.000

Total:

Rp200.000 + Rp100.000 = Rp300.000

---

## 20. Payroll Snapshot Principle

Ketika payroll dihitung dan kemudian approved/locked, hasil payroll harus dapat dipertahankan meskipun data konfigurasi berubah.

Contoh:

Performance tanggal 10:
Rate = Rp20.000

Payroll approved.

Kemudian rate jobdesk berubah menjadi Rp25.000.

Payroll lama tetap menggunakan rate Rp20.000.

Jangan menghitung ulang payroll lama berdasarkan rate terbaru.

---

## 21. Payroll Status

Status payroll:

- DRAFT
- CALCULATED
- APPROVED
- LOCKED

### DRAFT

Payroll belum final.

### CALCULATED

Sistem telah melakukan perhitungan.

### APPROVED

Payroll telah disetujui.

Member dapat melihat payroll setelah status minimal APPROVED.

### LOCKED

Payroll sudah dikunci.

Perubahan biasa tidak diperbolehkan.

Koreksi membutuhkan Super Admin dan harus menghasilkan audit log.

---

## 22. Manual Payroll Adjustment

Admin dapat memberikan:

- Bonus
- Manual Deduction

Adjustment harus menyimpan:

- amount
- reason
- createdBy
- createdAt

Manual adjustment tidak boleh mengubah historical performance.

---

## 23. Audit Logs

Collection: `/audit_logs/{auditLogId}`

Audit log digunakan untuk mencatat aktivitas administratif penting.

Member tidak memiliki akses.

### Fields

- auditLogId: String
- actorId: String
- actorRole: String
- action: String
- targetCollection: String
- targetId: String
- beforeData: Map | null
- afterData: Map | null
- reason: String | null
- createdAt: Timestamp

---

## 24. Audit Log Actors

Audit log mencatat aktivitas:

- Admin
- Super Admin

Member tidak memiliki akses untuk membaca audit log.

Super Admin memiliki akses penuh terhadap audit log.

Admin hanya dapat melihat audit log sesuai permission yang diberikan.

---

## 25. Important Audit Actions

Minimal action:

- CREATE_USER
- DISABLE_USER
- CHANGE_ROLE
- CREATE_JOBDESK
- UPDATE_JOBDESK
- CHANGE_RATE
- CREATE_ASSIGNMENT
- UPDATE_ASSIGNMENT
- END_ASSIGNMENT
- CANCEL_ASSIGNMENT
- CREATE_CREW_RECORD
- UPDATE_CREW_RECORD
- CANCEL_CREW_RECORD
- CREATE_PAYROLL_PERIOD
- UPDATE_PAYROLL_PERIOD
- CALCULATE_PAYROLL
- APPROVE_PAYROLL
- LOCK_PAYROLL
- MANUAL_ADJUSTMENT
- PERFORMANCE_CORRECTION
- EMERGENCY_CORRECTION

---

## 26. Historical Data Rules

Data berikut tidak boleh dihapus secara permanen jika sudah digunakan:

- Users
- Jobdesks
- Assignments
- Performances
- Crew activities
- Payrolls
- Payroll periods
- Audit logs

Gunakan status seperti:

- active
- inactive
- ended
- cancelled

jika data sudah tidak berlaku.

---

## 27. Historical Integrity

Perubahan data saat ini tidak boleh mengubah data historis.

Contoh:

Jobdesk rate berubah
→ Performance lama tetap menggunakan rate lama.

Assignment berubah
→ Performance lama tetap menggunakan assignment lama.

Member menjadi inactive
→ Performance dan payroll lama tetap tersedia.

Payroll approved
→ Perubahan konfigurasi berikutnya tidak mengubah payroll lama.

---

## 28. Member Joining Rules

Member baru memiliki `joinedAt`.

Tanggal tersebut menjadi awal eligibility untuk performance dan payroll.

Contoh:

Payroll:
01 Jun - 30 Jun

Member joined:
15 Jun

Member hanya dihitung mulai 15 Jun.

Target standar jobdesk dapat tetap menunjukkan:

Target Bulanan = 30

Tetapi target efektif disesuaikan berdasarkan tanggal member mulai bekerja.

Contoh:

Target standar = 30
Hari kerja efektif = 15

Target efektif = 15

Jika member menghasilkan 15 pekerjaan:

Achievement = 100%

Payroll tetap berdasarkan pekerjaan yang benar-benar dilakukan.

---

## 29. Performance and Payroll Relationship

Relationship:

users
→ assignments
→ performances
→ payrolls

Crew:

users
→ crew_activities
→ payrolls

Payroll period mengelompokkan performances dan crew_activities berdasarkan tanggal.

---

## 30. Assignment and Performance Relationship

Performance harus menyimpan `assignmentId` agar sistem mengetahui assignment yang berlaku ketika performance dibuat.

Performance juga menyimpan `jobdeskId` untuk menjaga historical reference terhadap jobdesk.

Jangan hanya melakukan lookup berdasarkan assignment aktif saat ini.

---

## 31. Date and Time Rules

Seluruh business date/time menggunakan:

Asia/Makassar
UTC+08:00
WITA

Field yang berkaitan dengan waktu menggunakan Firestore Timestamp.

Jangan menyimpan tanggal business-critical sebagai string jika dapat menggunakan Timestamp.

Tanggal yang hanya digunakan sebagai identifier atau filter kalender tetap harus diproses secara konsisten berdasarkan timezone WITA.

---

## 32. Firestore Security Principles

Firestore Security Rules wajib menerapkan role-based access.

### Member

- Hanya dapat membaca data miliknya.
- Dapat membuat performance miliknya.
- Tidak dapat membuat performance tanggal masa depan.
- Tidak dapat mengubah data user lain.
- Tidak dapat membaca payroll user lain.
- Tidak dapat membaca audit log.

### Admin

- Dapat mengakses data operasional.
- Dapat mengelola assignment.
- Dapat mengelola jobdesk sesuai permission.
- Dapat mengelola crew activity.
- Dapat melakukan monitoring performance.
- Tidak dapat melakukan Super Admin operation.

### Super Admin

- Memiliki akses administratif penuh.
- Dapat mengelola akun.
- Dapat mengelola role.
- Dapat melakukan koreksi sensitif.
- Dapat mengubah payroll period.
- Dapat melakukan emergency correction.
- Dapat membaca audit log.

Security Rules harus menjadi enforcement utama.

Flutter UI tidak dianggap sebagai security boundary.

---

## 33. Data Validation

Validasi harus dilakukan minimal pada:

- Required fields
- Valid user ID
- Valid assignment ID
- Valid jobdesk ID
- Valid date
- Valid rate
- Valid payroll period
- Valid status
- Valid role
- Valid permission

Jangan hanya melakukan validasi pada UI.

Validasi penting harus dilakukan kembali sebelum data disimpan.

---

## 34. Duplicate Prevention

Sistem harus mencegah duplicate performance untuk kombinasi yang sama.

Identitas logis:

memberId
+
assignmentId
+
workDate

Crew tidak menggunakan aturan ini karena satu member dapat memiliki beberapa crew activity pada hari yang sama.

Payroll harus memiliki satu record per:

payrollPeriodId
+
memberId

---

## 35. Recommended Firestore Indexes

Index harus dibuat sesuai query yang digunakan aplikasi.

Kemungkinan query penting:

performances:
- memberId + workDate
- assignmentId + workDate
- memberId + workDate + status

assignments:
- memberId + startDate
- jobdeskId + startDate

crew_activities:
- memberId + workDate

payrolls:
- payrollPeriodId + memberId

audit_logs:
- actorId + createdAt
- targetId + createdAt

AI Agent tidak boleh membuat index secara berlebihan.

Jika Firestore meminta composite index saat development, buat hanya index yang benar-benar dibutuhkan oleh query.

---

## 36. Data Ownership

### Member

Memiliki akses terhadap:

- Own user profile
- Own assignments
- Own performances
- Own payroll after approval

### Admin

Mengelola:

- Operational data
- Assignments
- Jobdesks
- Performance monitoring
- Crew
- Payroll

### Super Admin

Mengelola:

- Users
- Roles
- Administrative corrections
- Locked data corrections
- Payroll period corrections
- Audit logs

---

## 37. V1 Database Scope

Database V1 minimal terdiri dari:

- users
- jobdesks
- assignments
- performances
- crew_activities
- payroll_periods
- payrolls
- audit_logs

Jangan menambahkan database structure yang tidak diperlukan untuk V1.

---

## 38. Core Database Principles

Database harus mengikuti prinsip:

1. Historical data must remain trustworthy.
2. Current configuration must not overwrite historical facts.
3. Payroll must be reproducible.
4. Performance must remain traceable to its assignment.
5. Rate changes must not alter historical payroll.
6. Member inactivity must not delete historical records.
7. Administrative corrections must be auditable.
8. Security must be enforced through Firebase Security Rules.
9. Business-critical calculations must not depend on client-side state alone.
10. Firestore is the primary source of truth.

---

## 39. AI Agent Implementation Rules

Sebelum membuat atau mengubah database implementation, AI Agent wajib membaca:

- docs/PRD.md
- docs/ARCHITECTURE.md
- docs/DATABASE_SCHEMA.md
- docs/DESIGN.md
- docs/RULES.md

AI Agent tidak boleh:

- Mengubah struktur collection tanpa alasan.
- Menghapus historical data.
- Mengubah business rule hanya karena lebih mudah diimplementasikan.
- Menghapus field yang digunakan untuk historical calculation.
- Mengubah payroll calculation tanpa memperbarui dokumentasi.
- Membuat relation yang menyebabkan historical data berubah otomatis.

Jika perubahan database diperlukan:

1. Jelaskan alasan.
2. Jelaskan collection yang terdampak.
3. Jelaskan migration impact.
4. Pastikan historical data tetap aman.
5. Update DATABASE_SCHEMA.md jika struktur berubah.

---

## 40. Final Database Principle

Database harus sederhana tetapi memiliki historical integrity yang kuat.

Prioritas:

Data Integrity
>
Historical Accuracy
>
Security
>
Correct Payroll
>
Maintainability
>
Performance Optimization
>
Additional Features

Jangan mengorbankan historical accuracy hanya demi membuat implementasi lebih sederhana.