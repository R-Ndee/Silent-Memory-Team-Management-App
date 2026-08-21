# RULES.md

## 1. Purpose

Dokumen ini berisi aturan wajib yang harus diikuti oleh AI Agent selama mengembangkan aplikasi.

AI Agent harus memperlakukan dokumen berikut sebagai sumber utama project:

1. PRD.md
2. ARCHITECTURE.md
3. DATABASE_SCHEMA.md
4. DESIGN.md
5. RULES.md

Dokumen tersebut harus dibaca dan dipahami sebelum melakukan implementasi fitur yang relevan.

---

## 2. Core Principle

AI Agent bertugas mengimplementasikan requirement yang sudah ditentukan.

AI Agent bukan product manager dan tidak boleh mengubah business requirement berdasarkan asumsi pribadi.

Prinsip utama:

> Implement what is defined. Do not invent what is not defined.

Jika requirement belum jelas:

- Jangan membuat asumsi besar.
- Jangan membuat business rule baru.
- Jangan mengubah alur bisnis.
- Identifikasi bagian yang ambigu.
- Jika keputusan tersebut memengaruhi data, payroll, performance, authentication, authorization, atau business logic, tanyakan terlebih dahulu.

Untuk perubahan kecil yang tidak memengaruhi business logic dan dapat diselesaikan dengan aman, gunakan judgment yang paling konsisten dengan dokumentasi.

---

## 3. Documentation Priority

Jika terdapat perbedaan informasi antar dokumen, gunakan prioritas berikut:

1. Explicit user requirement / confirmed project decision.
2. PRD.md.
3. DATABASE_SCHEMA.md untuk aturan data.
4. ARCHITECTURE.md untuk keputusan teknis.
5. DESIGN.md untuk visual dan UX.
6. RULES.md untuk implementasi dan coding convention.
7. AI Agent judgment.

AI Agent tidak boleh menggunakan preferensi teknis pribadi untuk mengalahkan requirement yang sudah disepakati.

Jika konflik tidak dapat diselesaikan dengan jelas, hentikan implementasi bagian tersebut dan minta klarifikasi.

---

## 4. Read Before Coding

Sebelum mengimplementasikan fitur:

1. Baca PRD.md.
2. Baca bagian ARCHITECTURE.md yang relevan.
3. Baca DATABASE_SCHEMA.md jika fitur menyentuh database.
4. Baca DESIGN.md jika fitur menyentuh UI.
5. Baca RULES.md.
6. Periksa implementasi project yang sudah ada.
7. Identifikasi reusable component/provider/service yang dapat digunakan kembali.
8. Baru implementasikan fitur.

Jangan langsung membuat file baru sebelum memahami struktur project.

---

## 5. Scope Control

AI Agent harus bekerja sesuai scope task.

Jika task meminta:

"Tambahkan halaman Performance"

jangan otomatis:

- Mengubah authentication.
- Mengubah database schema.
- Mengganti navigation seluruh aplikasi.
- Mengganti theme.
- Memindahkan folder.
- Mengganti state management.
- Mengubah fitur lain.

kecuali perubahan tersebut memang diperlukan agar fitur dapat bekerja.

Jika perubahan tambahan memang diperlukan:

- Jelaskan alasannya.
- Lakukan perubahan seminimal mungkin.
- Jangan melakukan refactor besar tanpa kebutuhan.

---

## 6. No Unnecessary Refactoring

Jangan melakukan refactor hanya karena AI Agent memiliki preferensi struktur kode yang berbeda.

Kode yang sudah bekerja tidak boleh dirombak tanpa alasan teknis yang jelas.

Refactor diperbolehkan jika:

- Menghilangkan bug.
- Diperlukan oleh fitur baru.
- Mengurangi duplicate logic yang nyata.
- Meningkatkan maintainability secara signifikan.
- Diperlukan untuk security.
- Diperlukan untuk architecture yang sudah ditentukan.

Jangan melakukan "cleanup" besar ketika task hanya membutuhkan perubahan kecil.

---

## 7. Flutter Rules

Project menggunakan Flutter.

Gunakan Dart modern dan idiomatic.

Prioritaskan:

- Readable code.
- Null safety.
- Strong typing.
- Small focused widgets.
- Reusable components.
- Clear separation of concerns.
- Immutable state jika memungkinkan.

Hindari:

- Giant widget files.
- Business logic di UI widget.
- Duplicate UI code.
- Hard-coded configuration.
- Unnecessary global mutable state.
- Deeply nested widget structures jika dapat disederhanakan.

---

## 8. Project Structure

Gunakan struktur project yang telah ditentukan dalam ARCHITECTURE.md.

Jangan membuat struktur folder baru hanya karena AI Agent memiliki preferensi lain.

Jika folder baru memang diperlukan:

- Letakkan pada lokasi yang sesuai dengan architectural responsibility.
- Gunakan naming convention yang konsisten.
- Jangan mencampur UI, business logic, dan data access tanpa alasan.

---

## 9. Feature Organization

Feature harus diorganisasikan secara jelas.

Setiap feature sebaiknya memiliki separation antara:

- Presentation.
- State management.
- Domain/business logic.
- Data/repository access.

Jangan membuat satu file berisi:

- UI.
- Firebase query.
- Payroll calculation.
- Validation.
- Navigation.

secara sekaligus jika dapat dipisahkan secara reasonable.

---

## 10. Riverpod Rules

Riverpod digunakan sebagai state management.

Gunakan Riverpod untuk:

- Application state.
- Feature state.
- Async state.
- Dependency injection.
- Repository/service access jika sesuai.

Jangan menggunakan:

- Global mutable variables.
- State management library lain.
- Provider pattern alternatif yang tidak diperlukan.

Jangan memasukkan business logic kompleks langsung ke widget.

Business logic harus berada pada layer/provider/service yang sesuai.

Provider harus memiliki responsibility yang jelas.

Jangan membuat satu provider raksasa yang mengatur seluruh aplikasi.

---

## 11. Riverpod State Rules

State harus memiliki lifecycle yang jelas.

Pertimbangkan:

- Loading.
- Data.
- Empty.
- Error.

UI harus dapat menangani seluruh state tersebut.

Jangan mengasumsikan data selalu tersedia.

Jika asynchronous operation gagal:

- State harus merepresentasikan error.
- UI harus memberikan feedback yang sesuai.
- Jangan silently ignore error.

---

## 12. GoRouter Rules

GoRouter digunakan untuk navigation.

Routing harus centralized.

Jangan melakukan navigation logic secara acak di banyak tempat.

Route harus memiliki:

- Clear path.
- Clear screen purpose.
- Authentication consideration.
- Authorization consideration jika diperlukan.

Protected routes harus memeriksa authentication state.

Role-based access harus ditegakkan di application logic dan security layer, bukan hanya dengan menyembunyikan button.

---

## 13. Authentication Rules

Firebase Authentication digunakan untuk authentication.

Jangan membuat sistem authentication custom jika Firebase Authentication sudah memenuhi kebutuhan.

Authentication dan authorization harus dibedakan.

Authentication:

"Siapa user ini?"

Authorization:

"Apa yang boleh dilakukan user ini?"

Jangan menganggap user yang berhasil login otomatis memiliki akses admin.

Role harus diverifikasi melalui sumber data yang terpercaya.

---

## 14. Authorization Rules

Role utama aplikasi:

- Member.
- Admin.
- Super Admin.

Hak akses harus mengikuti requirement yang telah ditentukan.

UI visibility bukan security boundary.

Contoh:

Jika tombol "Manage Accounts" hanya terlihat oleh Super Admin, backend/security rules tetap harus mencegah Member atau Admin melakukan operasi tersebut.

Jangan mengandalkan:

```text
if (role == admin)
```

di UI sebagai satu-satunya protection.

---

## 15. Super Admin Rules

Super Admin memiliki permission administratif yang lebih tinggi sesuai requirement.

Contoh:

- Manage accounts.
- Mengubah payroll period.
- Mengubah assignment tertentu.
- Administrative corrections.

Namun jangan memberikan permission tambahan hanya karena secara teknis mudah dilakukan.

Permission harus mengikuti business requirement.

---

## 16. Firebase Rules

Firebase digunakan sebagai backend.

Gunakan Firebase sesuai architecture yang ditentukan.

Firebase access harus melalui layer yang sesuai.

Jangan menyebarkan direct database access ke seluruh widget.

UI tidak boleh langsung berisi query Firebase yang kompleks.

Gunakan repository/service/data layer sesuai ARCHITECTURE.md.

---

## 17. Firebase Security

Security rules harus menjadi bagian dari design aplikasi.

Jangan menganggap client-side validation sebagai security.

Client validation:

- Untuk UX.

Firebase Security Rules:

- Untuk authorization enforcement.

Sensitive operations harus diverifikasi di backend/security layer yang sesuai.

Jangan menyimpan secret key di client application.

Jangan memasukkan credential sensitif ke source code.

---

## 18. Database Rules

Database structure harus mengikuti DATABASE_SCHEMA.md.

Jangan menambah field atau collection baru tanpa alasan yang jelas.

Jika perubahan database diperlukan:

1. Identifikasi kebutuhan.
2. Periksa dampaknya.
3. Update DATABASE_SCHEMA.md jika perubahan merupakan bagian dari permanent design.
4. Implementasikan migration/backward compatibility jika diperlukan.

Jangan mengubah schema diam-diam.

---

## 19. Data Integrity

Data harus diperlakukan sebagai sumber kebenaran.

Jangan menghitung ulang historical data secara sembarangan.

Historical performance, assignment, payroll, dan status harus mempertahankan konteks waktu ketika diperlukan.

Jika business requirement menyatakan bahwa historical data harus tetap valid setelah assignment berubah, jangan overwrite historical record hanya karena assignment saat ini berubah.

Gunakan timestamp dan historical records jika diperlukan.

---

## 20. Performance Submission Rules

Member mengisi performance secara mandiri.

AI Agent tidak boleh mengubah sistem menjadi admin-input-only tanpa requirement baru.

Member dapat mengisi performance:

- Untuk hari ini.
- Untuk hari sebelumnya.

Member tidak boleh mengisi performance untuk tanggal masa depan.

Tanggal harus divalidasi menggunakan server/backend-authoritative time jika diperlukan.

Jangan mempercayai waktu device sebagai satu-satunya sumber kebenaran.

---

## 21. Date and Time Rules

Timezone aplikasi:

WITA / UTC+8.

Semua business date yang berkaitan dengan:

- Performance.
- Assignment.
- Deadline.
- Payroll.
- Work status.

harus konsisten menggunakan timezone yang telah ditentukan.

Jangan menggunakan timezone device secara sembarangan untuk business logic.

---

## 22. Deadline Rules

Waktu kerja dan deadline ditentukan oleh Admin sesuai requirement.

Contoh konfigurasi:

- Work period: 08:00–23:59.
- Late period: 00:00–00:59.
- Very Late period: 01:00–04:59.
- Not Done: mulai 05:00.

Nilai sebenarnya harus berasal dari configuration/business rules yang disepakati, bukan hard-coded tanpa alasan.

Jangan membuat timezone atau deadline logic baru di dalam widget.

---

## 23. Late and Historical Submission

Jika member mengisi performance setelah deadline:

Status harus dihitung berdasarkan waktu submission yang sebenarnya.

Jangan mengubah timestamp submission agar terlihat tepat waktu.

Jika member ingin memperbaiki historical submission:

- Member tidak boleh mengubah historical record secara bebas.
- Member harus meminta admin jika correction diperlukan.
- Admin harus melakukan correction melalui mekanisme yang sesuai.
- Correction harus dapat diaudit.

---

## 24. Assignment Rules

Assignment menentukan jobdesk yang harus dilakukan member.

Assignment memiliki konteks waktu.

Jika assignment berubah:

- Historical performance tidak boleh otomatis berubah menjadi assignment baru.
- Performance yang sudah disubmit harus tetap memiliki konteks assignment ketika submission terjadi.
- Assignment baru berlaku mulai dari effective date yang ditentukan.

Jangan overwrite historical assignment hanya karena current assignment berubah.

---

## 25. Assignment Changed After Performance Submission

Jika member sudah submit performance pada suatu tanggal lalu Admin mengubah assignment sehingga member tidak lagi memiliki tugas pada tanggal tersebut:

Historical submission tidak boleh dihapus.

Sistem harus mempertahankan record bahwa member memang sudah melakukan submission.

Perhitungan akhir harus mengikuti business rule yang telah ditentukan.

Jika perubahan assignment menyebabkan hari tersebut kemudian menjadi NOT_ASSIGNED:

- Submission tetap tersimpan.
- Historical activity tetap terlihat.
- Perhitungan payroll harus menggunakan aturan yang telah ditentukan.
- Jangan menghapus data hanya untuk membuat angka terlihat lebih bersih.

---

## 26. Target Rules

Target dapat berubah berdasarkan keputusan administratif yang valid.

Jika target awal berubah:

- Current target mengikuti target terbaru yang berlaku.
- Historical achievement tetap menyimpan actual performance.
- Actual performance tidak boleh dihapus atau dikurangi hanya karena target berubah.

Contoh:

Target awal:
30 jobs.

Member telah menyelesaikan:
20 jobs.

Target kemudian diubah menjadi:
15 jobs.

Actual:
20.

Current target:
15.

Sistem tidak boleh mengubah actual 20 menjadi 15.

---

## 27. New Member Rules

Member baru mulai dihitung sejak tanggal efektif masuk.

Jika member masuk di tengah payroll period:

- Achievement calculation menggunakan effective start date.
- Member tidak dianggap harus memenuhi pekerjaan sebelum tanggal mulai.
- Payroll mengikuti hari/performance yang memang menjadi tanggung jawab member.
- Target dan achievement harus mempertimbangkan dispensasi berdasarkan business rule.

Jangan menghukum member baru karena tanggal sebelum mereka bergabung.

---

## 28. Payroll Rules

Payroll merupakan data sensitif.

Payroll harus mengikuti:

- Payroll period.
- Performance.
- Assignment.
- Rate.
- Crew activity.
- Approved adjustment.
- Applicable business rules.

Jangan menghitung payroll berdasarkan UI state.

Payroll calculation harus berada pada business logic layer.

---

## 29. Payroll Visibility

Member tidak boleh melihat nominal payroll sebelum payroll selesai dan approved.

Sebelum approved, member hanya dapat melihat status yang relevan.

Setelah approved, nominal payroll dapat ditampilkan.

Tujuan:

- Menghindari fokus berlebihan pada nominal sementara payroll belum final.
- Mengurangi kebingungan akibat perubahan payroll.
- Menjaga payroll sebagai hasil final yang telah disetujui.

Jangan membocorkan preliminary payroll calculation melalui endpoint atau UI yang dapat diakses member.

---

## 30. Payroll Locking

Payroll memiliki lifecycle.

Contoh:

Draft
→ Calculated
→ Review
→ Approved
→ Locked

Setelah payroll locked:

- Jangan mengubah data secara langsung.
- Correction harus menggunakan mekanisme administrative correction.
- Historical payroll harus tetap dapat diaudit.

Super Admin dapat melakukan perubahan terhadap payroll period jika requirement mengizinkan.

Namun perubahan tersebut harus tetap mengikuti audit trail.

---

## 31. Audit Log

Audit log digunakan untuk mencatat tindakan penting.

Minimal aktor:

- Super Admin.
- Admin.
- Member jika melakukan action yang memang perlu dicatat.

Audit log harus mencatat tindakan yang memengaruhi data penting.

Contoh:

- Account creation.
- Account disabling.
- Role change.
- Assignment change.
- Performance correction.
- Payroll modification.
- Payroll approval.
- Payroll locking.
- Administrative override.

Audit log harus menyimpan informasi seperti:

- Actor.
- Action.
- Target record.
- Timestamp.
- Relevant previous value jika diperlukan.
- Relevant new value jika diperlukan.
- Reason/note jika diperlukan.

---

## 32. Audit Log Immutability

Audit log tidak boleh diedit oleh user biasa.

Jangan menyediakan fitur delete audit log tanpa requirement keamanan dan administrative process yang jelas.

Audit log harus diperlakukan sebagai historical record.

---

## 33. Error Handling

Setiap operation penting harus menangani:

- Loading.
- Success.
- Failure.

Error message harus:

- Jelas.
- Singkat.
- Tidak membocorkan informasi sensitif.
- Memberikan tindakan jika memungkinkan.

Jangan menggunakan generic error untuk semua kondisi.

---

## 34. Validation

Validation harus dilakukan pada dua sisi jika diperlukan:

Client:

- UX.
- Immediate feedback.

Backend/security:

- Data integrity.
- Authorization.
- Security.

Jangan mempercayai client input.

Semua input dari client harus dianggap untrusted.

---

## 35. Duplicate Prevention

Action yang dapat menghasilkan duplicate record harus memiliki protection.

Contoh:

Performance submission.

Jika user menekan Submit beberapa kali:

- Jangan membuat duplicate performance.
- Button dapat disabled selama request berlangsung.
- Backend/database harus tetap memiliki constraint atau logic yang mencegah duplicate jika diperlukan.

---

## 36. Concurrency

AI Agent harus mempertimbangkan kondisi ketika dua admin melakukan perubahan pada data yang sama.

Contoh:

- Assignment berubah.
- Payroll diubah.
- Member account diubah.

Jangan mengasumsikan hanya satu client yang aktif.

Gunakan transaction, atomic update, versioning, atau mechanism yang sesuai jika diperlukan.

---

## 37. Hard-coded Values

Jangan hard-code:

- User ID.
- Firebase document ID.
- Payroll rate.
- Role.
- Business status.
- Deadline.
- Target.
- Date.
- Configuration.

kecuali nilai tersebut memang merupakan constant yang secara eksplisit ditentukan sebagai static configuration.

Business rules sebaiknya berasal dari data/configuration yang sesuai.

---

## 38. Dependency Rules

Jangan menambahkan package/dependency baru hanya karena ada cara yang lebih mudah.

Sebelum menambahkan dependency:

1. Periksa apakah Flutter/Dart sudah menyediakan functionality tersebut.
2. Periksa dependency yang sudah digunakan.
3. Pastikan dependency benar-benar diperlukan.
4. Pertimbangkan maintenance dan security.
5. Jika dependency memengaruhi architecture, jelaskan terlebih dahulu.

Jangan menambahkan library besar untuk menyelesaikan masalah kecil.

---

## 39. Package Consistency

Gunakan dependency yang sudah disepakati:

- Riverpod.
- GoRouter.
- Firebase.

Jangan menambahkan state management atau routing framework lain tanpa keputusan baru.

Jangan mengganti Riverpod atau GoRouter hanya karena AI Agent memiliki preference lain.

---

## 40. Reusable Components

Jika UI component digunakan lebih dari satu tempat dan memiliki behavior yang sama, pertimbangkan membuat reusable component.

Contoh:

- AppButton.
- StatusBadge.
- AppTextField.
- AppCard.
- LoadingState.
- ErrorState.
- EmptyState.

Namun jangan membuat abstraction terlalu dini.

Jangan membuat component generic yang terlalu kompleks hanya untuk menghindari beberapa baris duplicate code.

---

## 41. Business Logic Separation

Business logic tidak boleh bergantung langsung pada Flutter UI.

Contoh business logic:

- Payroll calculation.
- Achievement calculation.
- Late status calculation.
- Assignment validity.
- Target calculation.
- Permission validation.

Logic tersebut harus dapat diuji tanpa harus menjalankan seluruh UI.

---

## 42. UI Rules

Widget harus fokus pada presentation dan user interaction.

Jangan melakukan:

- Complex Firebase query.
- Complex payroll calculation.
- Large business rules.
- Authorization logic utama.

langsung di build method.

Jika build method menjadi terlalu kompleks, pecah menjadi widget/component yang lebih kecil.

---

## 43. Naming

Gunakan naming yang jelas dan deskriptif.

Dart conventions:

- Classes: PascalCase.
- Variables/functions: camelCase.
- Constants: lowerCamelCase sesuai Dart convention.
- Files: snake_case.

Nama harus menjelaskan purpose.

Hindari:

- `Data`.
- `Manager`.
- `Helper`.
- `Utils`.

jika nama tersebut terlalu generic.

Lebih baik:

- `PayrollCalculator`.
- `PerformanceRepository`.
- `AssignmentProvider`.

daripada:

- `Helper`.
- `DataManager`.

---

## 44. Comments

Comment digunakan untuk menjelaskan:

- Kenapa sebuah keputusan dibuat.
- Business rule yang tidak obvious.
- Workaround.
- Constraint teknis.

Jangan menulis comment yang hanya mengulang kode.

Buruk:

```text
// Set loading to true
```

Lebih berguna:

```text
// Prevent duplicate performance submissions while the current request is being processed.
```

---

## 45. Logging

Logging harus digunakan untuk debugging tanpa membocorkan data sensitif.

Jangan log:

- Password.
- Authentication token.
- Sensitive payroll data jika tidak diperlukan.
- Personal information yang tidak diperlukan.

Production logging harus lebih restrained daripada development logging.

---

## 46. Secrets

Jangan menyimpan:

- Password.
- API secret.
- Private key.
- Service account credential.

di source code.

Firebase configuration yang memang public/client-safe tetap harus dibedakan dari actual secret.

---

## 47. Testing

Feature penting harus memiliki test yang sesuai.

Prioritas testing:

1. Business logic.
2. Payroll calculation.
3. Performance status.
4. Assignment behavior.
5. Authentication/authorization.
6. Critical UI interaction.
7. Repository/data operations.

Business logic harus lebih diprioritaskan daripada testing visual kecil yang tidak kritis.

---

## 48. Business Logic Test Cases

Minimal test untuk:

- On-time submission.
- Late submission.
- Very late submission.
- Not done.
- Future date submission rejection.
- Previous date submission.
- Assignment change.
- Assignment change after submission.
- Target change.
- New member joining mid-period.
- Payroll approval.
- Payroll lock.
- Unauthorized access.

---

## 49. Security Testing

Pastikan:

- Member tidak dapat mengakses admin operation.
- Admin tidak dapat mengakses Super Admin-only operation.
- User tidak dapat mengubah user ID miliknya menjadi user lain.
- User tidak dapat submit future performance.
- User tidak dapat membaca payroll yang belum approved.
- Historical records tidak dapat diubah secara bebas.
- Audit logs tidak dapat dimanipulasi oleh unauthorized user.

---

## 50. AI Agent Change Discipline

Sebelum mengubah file:

1. Baca file tersebut.
2. Pahami existing implementation.
3. Cari dependency terhadap file tersebut.
4. Tentukan perubahan minimum yang diperlukan.
5. Implementasikan.
6. Periksa apakah perubahan merusak fitur lain.

Jangan overwrite file secara membabi buta.

---

## 51. Preserve Existing Work

AI Agent tidak boleh menghapus hasil kerja yang sudah ada tanpa alasan.

Jangan:

- Menghapus screen yang belum diminta.
- Menghapus provider yang masih digunakan.
- Menghapus component yang masih digunakan.
- Menghapus database field tanpa migration.
- Menghapus business logic hanya karena belum digunakan saat ini.

Jika menemukan code yang terlihat buruk tetapi tidak relevan dengan task:

Jangan otomatis memperbaikinya.

---

## 52. Generated Code Review

Code yang dihasilkan AI tetap harus dianggap belum tentu benar.

Setelah implementasi:

1. Review compile errors.
2. Review analyzer warnings.
3. Review business logic.
4. Review security.
5. Review UI consistency.
6. Review affected features.
7. Run tests yang relevan.

Jangan menganggap "build berhasil" berarti feature benar.

---

## 53. Before Completing a Task

Sebelum menyatakan task selesai:

- Pastikan requirement terpenuhi.
- Pastikan tidak ada compile error.
- Pastikan analyzer tidak memiliki error baru.
- Pastikan navigation bekerja.
- Pastikan state loading/error/empty ditangani.
- Pastikan authorization sesuai.
- Pastikan database operation sesuai schema.
- Pastikan design mengikuti DESIGN.md.
- Pastikan tidak ada unrelated modification.

---

## 54. When Requirements Are Ambiguous

Jika requirement ambigu tetapi tidak berdampak besar:

Gunakan pendekatan paling sederhana yang konsisten dengan dokumentasi.

Jika requirement ambigu dan berdampak pada:

- Payroll.
- Performance.
- Assignment.
- Authentication.
- Authorization.
- Database schema.
- Historical data.
- Security.

Jangan mengambil keputusan sendiri.

Tanyakan terlebih dahulu.

---

## 55. No Silent Business Rule Changes

AI Agent tidak boleh mengubah:

- Payroll formula.
- Performance calculation.
- Assignment behavior.
- Target calculation.
- Late classification.
- User permissions.

secara diam-diam.

Jika implementasi membutuhkan perubahan business rule:

- Stop pada bagian tersebut.
- Jelaskan conflict.
- Minta confirmation.

---

## 56. Data Preservation

Historical data harus diperlakukan sebagai valuable record.

Jangan delete atau overwrite historical data hanya untuk menyederhanakan implementation.

Jika business rule membutuhkan perubahan:

Gunakan:

- Effective date.
- Historical record.
- Audit log.
- Correction record.

sesuai architecture.

---

## 57. Date Integrity

Business date harus disimpan dan dibandingkan secara konsisten.

Jangan menggunakan string date yang formatnya tidak konsisten.

Jangan membandingkan tanggal menggunakan local device timezone jika business timezone adalah WITA.

Pastikan:

- Submission date.
- Assignment effective date.
- Payroll period.
- Deadline.

menggunakan representation yang konsisten.

---

## 58. Performance Submission Integrity

Performance submission harus menyimpan informasi yang diperlukan untuk mempertahankan historical context.

Minimal pertimbangkan:

- Member.
- Job/assignment.
- Work date.
- Submission timestamp.
- Status.
- Optional note.
- Relevant assignment context.

Jangan mengandalkan current assignment untuk merekonstruksi historical performance jika assignment dapat berubah.

---

## 59. Administrative Corrections

Jika admin melakukan correction terhadap historical performance:

Correction harus:

- Explicit.
- Authorized.
- Auditable.
- Memiliki reason jika diperlukan.

Jangan silently mutate historical data.

---

## 60. Account Management

Account creation dan account management mengikuti role permission.

Jika requirement menetapkan bahwa hanya Super Admin yang dapat membuat/mengelola akun:

Admin biasa tidak boleh mendapatkan permission tersebut.

Authentication credential harus ditangani melalui Firebase Authentication.

Jangan menyimpan password plaintext di database.

---

## 61. Role Changes

Role change adalah sensitive operation.

Role change harus:

- Authorized.
- Validated.
- Audited.

Jangan mengubah role hanya dari client-side UI tanpa backend/security enforcement.

---

## 62. UI and Security

Menyembunyikan button bukan security.

Contoh:

Jika Member tidak boleh mengakses Payroll Management:

Jangan hanya menyembunyikan menu.

Route dan backend/data access juga harus menolak unauthorized access.

---

## 63. Design Compliance

Semua UI harus mengikuti DESIGN.md.

AI Agent tidak boleh menggunakan:

- Random colors.
- Random font sizes.
- Random radius.
- Random shadows.
- Random component styles.

jika token/component yang sesuai sudah tersedia.

Jika membuat component baru:

Pastikan component tersebut sesuai dengan visual language DESIGN.md.

---

## 64. No Screenshot-Driven Coding

Screenshot reference bukan alasan untuk hard-code layout secara berlebihan.

Gunakan screenshot untuk memahami design intent.

Implementasikan design menggunakan:

- Theme.
- Design tokens.
- Reusable components.
- Responsive layout.

Jangan membuat UI hanya agar satu screenshot terlihat sama tetapi rusak pada device lain.

---

## 65. Mobile-First Rules

V1 diprioritaskan untuk smartphone.

Pastikan:

- Touch target nyaman.
- Text readable.
- Scroll behavior benar.
- Keyboard tidak menutup input penting.
- Bottom navigation tidak menutupi content.
- Safe area digunakan.
- Layout bekerja pada width berbeda.

Jangan membuat desktop-style UI di V1.

---

## 66. Future Platform Compatibility

Walaupun V1 mobile-first, jangan membuat code yang secara tidak perlu bergantung pada Android-only behavior.

Jika menggunakan platform-specific feature:

- Isolate platform-specific code.
- Dokumentasikan alasan.
- Pastikan architecture tetap memungkinkan platform lain di masa depan.

---

## 67. Performance

Prioritaskan performance yang realistis.

Hindari:

- Unnecessary rebuilds.
- Unnecessary Firebase reads.
- Loading seluruh collection jika hanya membutuhkan subset data.
- Repeated network request.
- Heavy image loading.
- Large widget rebuilds.

Gunakan pagination, filtering, caching, atau optimization jika memang dibutuhkan.

Jangan melakukan premature optimization yang membuat code sulit dipahami.

---

## 68. Firebase Query Discipline

Jangan mengambil seluruh dataset jika hanya membutuhkan sebagian.

Gunakan query yang tepat.

Pertimbangkan:

- Filtering.
- Ordering.
- Limit.
- Pagination.

Firestore reads harus diperhatikan karena berhubungan dengan scalability dan cost.

---

## 69. Cost Awareness

AI Agent harus mempertimbangkan Firebase usage.

Jangan membuat listener realtime pada data yang tidak membutuhkan realtime update.

Gunakan realtime listener hanya ketika business requirement memang membutuhkan realtime behavior.

---

## 70. Accessibility and UX

Accessibility bukan optional polish.

Pastikan:

- Text readable.
- Buttons usable.
- Status memiliki text/icon selain color.
- Error mudah dipahami.
- User tidak dipaksa mengingat icon tanpa label jika context tidak jelas.

---

## 71. Implementation Order

Untuk feature baru:

1. Understand requirement.
2. Check documentation.
3. Check architecture.
4. Check existing implementation.
5. Define data flow.
6. Implement data/domain logic.
7. Implement state management.
8. Implement navigation.
9. Implement UI.
10. Handle loading/error/empty states.
11. Add validation.
12. Add tests.
13. Review security.
14. Review design.
15. Run analyzer/build/tests.

Jangan langsung membuat UI sebelum memahami data flow jika feature membutuhkan backend.

---

## 72. Minimal Change Principle

Ketika menyelesaikan task:

> Make the smallest change that correctly solves the problem.

Jangan mengubah sepuluh file jika tiga file sudah cukup.

Namun jangan memaksakan perubahan kecil jika architecture memang membutuhkan separation yang lebih baik.

Minimal change bukan berarti bad architecture.

---

## 73. No Overengineering

Jangan membuat:

- Abstraction yang belum diperlukan.
- Generic framework di atas framework.
- Service layer berlebihan.
- Repository abstraction yang tidak memberikan value.
- Configuration system kompleks untuk satu constant.
- Dependency tambahan tanpa kebutuhan.

Project harus tetap dapat dipahami oleh developer manusia.

---

## 74. Human Maintainability

Code harus mudah dipahami oleh developer lain.

Prioritaskan:

- Clear naming.
- Predictable structure.
- Small responsibilities.
- Consistent patterns.
- Simple implementation.

Jangan membuat code terlihat "pintar" tetapi sulit dipelihara.

---

## 75. Completion Standard

AI Agent hanya boleh menyatakan task selesai jika:

- Requirement telah diimplementasikan.
- Tidak ada known blocking error.
- Tidak ada unauthorized access yang jelas.
- Tidak ada obvious data integrity issue.
- Design mengikuti DESIGN.md.
- Architecture mengikuti ARCHITECTURE.md.
- Database mengikuti DATABASE_SCHEMA.md.
- Tidak ada unrelated destructive change.
- Relevant tests telah dijalankan atau alasan tidak menjalankannya telah dijelaskan.

---

## 76. Final Rule

Jika ragu:

> Do not guess about business-critical behavior.

Jika perubahan bersifat kecil dan aman:

> Prefer the simplest implementation consistent with the existing architecture.

Jika perubahan berdampak pada data atau business logic:

> Stop, identify the ambiguity, and ask for clarification.

Jika sebuah solusi terlihat lebih "canggih" tetapi tidak diperlukan:

> Prefer the simpler solution.

Jika AI Agent menemukan sesuatu yang menurutnya dapat dibuat lebih baik tetapi berada di luar scope:

> Do not change it unless requested or required.

Tujuan AI Agent bukan membuat project terlihat kompleks.

Tujuannya adalah membuat aplikasi yang:

- benar,
- aman,
- mudah dipahami,
- mudah dirawat,
- konsisten,
- dan sesuai requirement.