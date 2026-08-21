# ARCHITECTURE.md

## 1. Project Overview

Aplikasi ini adalah aplikasi internal untuk mengelola kinerja dan payroll tim photography.

Aplikasi digunakan secara online oleh tiga role:

1. Member
2. Admin
3. Super Admin

Aplikasi digunakan untuk:

- Mengelola akun pengguna.
- Mengelola member dan status aktif/nonaktif.
- Mengelola jobdesk dan assignment.
- Mencatat kinerja harian member.
- Menghitung status pekerjaan berdasarkan waktu submission.
- Mencatat aktivitas crew pemotretan.
- Menghasilkan rekap kinerja.
- Menghitung payroll berdasarkan realisasi pekerjaan dan aktivitas crew.
- Mengelola payroll period.
- Menyimpan histori perubahan data penting.
- Menyediakan audit log untuk aktivitas administratif.

Aplikasi tidak menggunakan sistem attendance/absensi terpisah.

Kehadiran atau aktivitas kerja ditentukan berdasarkan submission kinerja dan assignment yang berlaku.


## 2. Technology Stack

### Frontend

- Flutter
- Dart

### State Management

- Riverpod

### Navigation

- GoRouter

### Backend / Cloud

- Firebase

### Authentication

- Firebase Authentication

### Database

- Cloud Firestore

### Local Storage

Tidak menggunakan local database sebagai sumber data utama.

SharedPreferences/Hive tidak digunakan sebagai database utama aplikasi.

Local storage hanya boleh digunakan jika diperlukan untuk kebutuhan ringan seperti:

- Preferensi UI.
- Cache sederhana.
- Informasi non-kritis.

Data bisnis utama harus selalu berasal dari Firebase.


## 3. Architectural Style

Gunakan arsitektur sederhana berbasis:

UI / Screens
↓
Riverpod Providers
↓
Services
↓
Firebase

Jangan menggunakan Clean Architecture yang terlalu kompleks untuk versi 1.0.

Tidak perlu membuat terlalu banyak abstraction layer seperti:

- Presentation
- Domain
- Data
- Repository
- Repository Implementation
- Use Case
- Entity
- DTO
- Mapper

kecuali benar-benar diperlukan.

Prioritas utama:

- Mudah dipahami.
- Mudah dikembangkan.
- Mudah diperbaiki.
- Cocok untuk project Flutter skala kecil-menengah.
- Tidak overengineering.


## 4. High-Level Data Flow

Alur umum aplikasi:

User
↓
Flutter UI
↓
Riverpod
↓
Service
↓
Firebase Authentication / Firestore
↓
Firebase
↓
Service
↓
Riverpod
↓
Flutter UI

Contoh:

Member membuka halaman Daily Performance
↓
Performance Provider mengambil assignment aktif
↓
Member mengisi hasil pekerjaan
↓
Performance Service melakukan validasi
↓
Firestore menyimpan performance record
↓
Riverpod melakukan refresh
↓
UI menampilkan status terbaru


## 5. Authentication

Gunakan Firebase Authentication.

Jangan membuat sistem login/password sendiri di database.

Akun dibuat dan dikelola oleh Super Admin.

Member tidak melakukan registrasi bebas.

Alur akun:

Super Admin membuat akun
↓
Firebase Authentication membuat user
↓
User mendapatkan email/password
↓
User login
↓
Firebase Authentication melakukan autentikasi
↓
Firestore menyimpan informasi profile dan role
↓
Aplikasi menentukan akses berdasarkan role

Role:

- member
- admin
- super_admin

Role tidak boleh hanya dipercaya dari data UI.

Permission harus divalidasi kembali melalui Firebase Security Rules.


## 6. Role Architecture

### 6.1 Member

Member dapat:

- Login.
- Melihat dashboard pribadi.
- Melihat assignment/jobdesk miliknya.
- Menginput performance.
- Menginput performance untuk tanggal hari ini.
- Menginput performance untuk tanggal sebelumnya.
- Melihat histori performance pribadi.
- Melihat status performance pribadi.
- Melihat achievement pribadi.
- Melihat payroll setelah payroll period selesai dan approved.
- Melihat informasi gaji miliknya setelah payroll approved.

Member tidak dapat:

- Membuat akun.
- Mengubah akun pengguna lain.
- Mengubah assignment.
- Mengubah jobdesk.
- Mengubah payroll.
- Melihat payroll member lain.
- Melihat audit log.
- Mengubah performance yang sudah disubmit secara langsung.
- Menginput performance untuk tanggal masa depan.


### 6.2 Admin

Admin dapat:

- Melihat dashboard operasional.
- Melihat member aktif.
- Melihat performance seluruh member.
- Melihat histori performance.
- Mengelola assignment.
- Menentukan apakah member memiliki tugas pada tanggal tertentu.
- Membuat assignment.
- Mengubah assignment yang belum terkunci.
- Mengelola jobdesk sesuai permission.
- Melihat aktivitas crew.
- Mencatat crew pemotretan.
- Melihat rekap performance.
- Membuat payroll period.
- Menghitung payroll.
- Menambahkan bonus/potongan manual.
- Melakukan proses payroll.
- Melakukan approval payroll sesuai workflow.
- Melihat data payroll setelah diproses.
- Melihat audit log sesuai permission.

Admin tidak dapat:

- Membuat atau menghapus akun pengguna.
- Mengubah role pengguna.
- Mengubah data sensitif yang sudah dikunci.
- Mengubah payroll period yang sudah terkunci tanpa Super Admin.
- Mengubah performance yang sudah disubmit secara diam-diam.


### 6.3 Super Admin

Super Admin memiliki seluruh akses Admin ditambah akses administratif tingkat tinggi.

Super Admin dapat:

- Membuat akun.
- Menonaktifkan akun.
- Mengubah role.
- Mengelola user.
- Melakukan perubahan pada assignment yang sudah approved/locked.
- Mengubah payroll period yang sudah dibuat.
- Menambahkan atau mengurangi tanggal payroll period.
- Melakukan koreksi data penting.
- Mengakses audit log lengkap.
- Melakukan emergency correction.

Super Admin digunakan untuk perubahan penting dan kondisi khusus.

Super Admin tidak boleh digunakan untuk aktivitas operasional harian jika tidak diperlukan.


## 7. Navigation Architecture

Gunakan GoRouter untuk seluruh navigasi.

Routing harus mempertimbangkan:

- Authentication state.
- User role.
- Route protection.

Contoh struktur:

/login

/member
/member/dashboard
/member/performance
/member/performance/history
/member/payroll

/admin
/admin/dashboard
/admin/performance
/admin/assignments
/admin/jobdesks
/admin/crew
/admin/payroll
/admin/payroll/detail

/super-admin
/super-admin/users
/super-admin/audit-log
/super-admin/settings

Route harus menolak akses jika role tidak memiliki permission.

Contoh:

- Member tidak boleh membuka /admin.
- Admin tidak boleh membuka /super-admin/users.
- Super Admin dapat mengakses area Admin dan Super Admin.


## 8. State Management

Gunakan Riverpod.

Riverpod digunakan untuk:

- Authentication state.
- Current user.
- Current role.
- Assignment data.
- Performance data.
- Payroll data.
- Jobdesk data.
- Crew activity.
- Dashboard statistics.
- Audit log.
- Loading state.
- Error state.

Provider harus memiliki tanggung jawab yang jelas.

Hindari satu provider besar yang mengelola seluruh aplikasi.

Contoh:

- authProvider
- currentUserProvider
- userRoleProvider
- assignmentProvider
- jobdeskProvider
- dailyPerformanceProvider
- performanceHistoryProvider
- crewActivityProvider
- payrollPeriodProvider
- payrollProvider
- dashboardProvider
- auditLogProvider

Nama provider dapat disesuaikan saat implementasi selama tanggung jawabnya tetap sama.


## 9. Service Layer

Firebase interaction tidak boleh ditulis langsung berulang-ulang di dalam Widget.

Gunakan service untuk operasi Firebase.

Contoh:

- AuthService
- UserService
- AssignmentService
- JobdeskService
- PerformanceService
- CrewService
- PayrollService
- AuditLogService

Contoh:

PerformanceScreen
↓
PerformanceProvider
↓
PerformanceService
↓
Firestore

Widget bertanggung jawab terhadap UI.

Provider bertanggung jawab terhadap state.

Service bertanggung jawab terhadap operasi data dan business operation yang berkaitan dengan Firebase.


## 10. Firestore as Source of Truth

Cloud Firestore merupakan sumber data utama.

Jangan menyimpan hasil perhitungan penting hanya di local state.

Contoh data yang harus dapat dihitung ulang dari Firestore:

- Jumlah pekerjaan.
- Achievement.
- Status pekerjaan.
- Total payroll.
- Crew compensation.
- Payroll period.
- Histori assignment.

Jika aplikasi ditutup lalu dibuka kembali, data harus tetap dapat diperoleh dari Firebase.


## 11. Performance Architecture

Tidak ada sistem attendance.

Performance ditentukan berdasarkan:

Assignment
+
Performance Submission
+
Submission Time

Member hanya dapat melakukan submission untuk:

- Hari ini.
- Tanggal sebelumnya.

Member tidak dapat melakukan submission untuk tanggal masa depan.

Tanggal default pada form adalah tanggal hari ini.

Tanggal dapat diganti ke tanggal sebelumnya untuk memperbaiki keterlambatan input.


## 12. Performance Submission

Ketika member mengirim performance:

Member
↓
Pilih tanggal
↓
Pilih assignment/jobdesk
↓
Input status
↓
Optional note
↓
Submit

Tanggal masa depan harus ditolak.

Jika tanggal submission berbeda dengan tanggal kerja yang dipilih, sistem mencatat waktu submission sebenarnya.

Contoh:

Work Date:
2026-08-10

Submitted At:
2026-08-11 09:30 WITA

Dengan demikian sistem dapat mengetahui bahwa performance untuk 10 Agustus baru diinput pada 11 Agustus.


## 13. Performance Status

Untuk V1, status utama performance adalah:

- NOT_ASSIGNED
- NOT_DONE
- DONE
- LATE
- VERY_LATE

### NOT_ASSIGNED

Member tidak memiliki tugas pada tanggal tersebut.

### NOT_DONE

Member memiliki assignment tetapi tidak melakukan submission sampai melewati batas waktu yang ditentukan.

### DONE

Performance dibuat tepat waktu.

### LATE

Performance dibuat setelah deadline tetapi masih berada dalam batas late.

### VERY_LATE

Performance dibuat sangat terlambat tetapi masih belum masuk kategori NOT_DONE.

Status ditentukan oleh sistem berdasarkan:

- Assignment.
- Deadline.
- Waktu submission.


## 14. Performance Score

Untuk V1, realisasi dan achievement harus dipisahkan.

### Realisasi

Realisasi adalah jumlah pekerjaan yang benar-benar dibuat.

Contoh:

10 assignment
8 pekerjaan dibuat

Realisasi = 8


### Achievement

Achievement mempertimbangkan ketepatan waktu.

Nilai awal:

DONE = 1.00
LATE = 0.75
VERY_LATE = 0.50
NOT_DONE = 0.00

Achievement dapat dihitung berdasarkan bobot tersebut.

Contoh:

10 tugas:

6 DONE
2 LATE
1 VERY_LATE
1 NOT_DONE

Achievement Score
= (6 × 1.00)
+ (2 × 0.75)
+ (1 × 0.50)
+ (1 × 0.00)

= 8.00 / 10
= 80%

Perhitungan ini hanya memengaruhi achievement/performance evaluation.

Untuk V1, keterlambatan tidak mengurangi upah utama berdasarkan pekerjaan yang berhasil direalisasikan.


## 15. Payroll Architecture

Payroll dihitung berdasarkan:

Realisasi pekerjaan
+
Crew compensation
+
Bonus manual
-
Potongan manual

Achievement tidak otomatis mengurangi gaji pada V1.

Sistem pemotongan gaji berdasarkan keterlambatan dapat ditambahkan pada versi berikutnya.


## 16. Payroll Visibility

Member tidak dapat melihat nominal payroll yang sedang berjalan.

Member hanya dapat melihat payroll miliknya setelah:

Payroll period selesai
↓
Payroll dihitung
↓
Payroll approved
↓
Payroll dapat dilihat Member

Tujuannya agar member fokus pada pekerjaan dan tidak terus-menerus memantau nominal gaji selama periode berjalan.

Admin dapat melihat payroll sesuai permission.

Super Admin dapat melakukan koreksi terhadap payroll yang sudah terkunci jika diperlukan.


## 17. Payroll Period

Payroll menggunakan periode yang dapat ditentukan oleh Admin.

Contoh:

Start:
2026-06-01

End:
2026-07-15

Sistem otomatis menghitung performance dalam rentang:

2026-06-01 → 2026-07-15

Payroll period tidak harus selalu tepat satu bulan kalender.

Super Admin dapat mengubah atau menambahkan tanggal payroll period jika diperlukan.


## 18. Assignment Architecture

Assignment merupakan hubungan antara:

Member
+
Jobdesk
+
Periode berlaku

Assignment tidak boleh hanya menyimpan jobdesk saat ini.

Sistem harus mempertahankan histori assignment.

Contoh:

Member A
Video Editor
01 Jun → 10 Jun

Member B
Video Editor
11 Jun → sekarang

Performance tanggal 1–10 Juni tetap menggunakan assignment Member A.

Performance tanggal 11 Juni dan seterusnya menggunakan assignment Member B.


## 19. Assignment Historical Integrity

Data historis tidak boleh berubah hanya karena assignment saat ini berubah.

Contoh:

1–10 Juni:
Member A mengerjakan Video Editor.

11 Juni:
Assignment dipindahkan ke Member B.

Sistem tidak boleh mengubah performance Member A menjadi milik Member B.

Performance harus mempertahankan referensi assignment/jobdesk/rate yang berlaku saat pekerjaan tersebut dibuat.


## 20. Assignment Change After Performance Submission

Jika member sudah melakukan performance submission kemudian Admin mengubah assignment hari tersebut menjadi NOT_ASSIGNED, data performance sebelumnya tidak boleh dihapus secara otomatis.

Sistem harus mempertahankan:

- Performance submission.
- Waktu submission.
- Assignment saat submission.
- Status awal.
- Perubahan assignment.
- Alasan perubahan jika diperlukan.

Perubahan tersebut harus dapat dilacak melalui audit/history.

Output payroll harus mengikuti aturan bisnis:

- Pekerjaan yang benar-benar sudah dilakukan tetap dihargai.
- Perubahan assignment tidak boleh secara diam-diam menghapus hak pembayaran.
- Histori tetap transparan.


## 21. Jobdesk Architecture

Jobdesk merupakan definisi pekerjaan.

Contoh:

- Up Story
- Upload Postingan
- Editing Project
- Send Konten
- Research Konten

Jobdesk memiliki informasi seperti:

- Nama.
- Kode.
- Deadline.
- Target.
- Rate.
- Kategori.
- Status aktif/nonaktif.

Jobdesk dapat berubah sepanjang waktu.

Namun perubahan jobdesk tidak boleh merusak histori performance atau payroll sebelumnya.


## 22. Jobdesk Rate History

Rate harus dapat dipertahankan secara historis.

Contoh:

Video Editor
Rate:
Rp20.000

Tanggal 1–10:
Member A

Tanggal 11:
Rate berubah menjadi Rp25.000

Performance sebelum perubahan tetap menggunakan rate lama.

Performance setelah perubahan menggunakan rate baru.

Jangan menghitung ulang payroll lama hanya karena rate saat ini berubah.


## 23. Member Joining

Member baru dapat masuk di tengah payroll period.

Contoh:

Payroll period:
1–30 Juni

Member masuk:
15 Juni

Member dianggap mulai bekerja dari tanggal masuk.

Target nominal jobdesk tetap dapat menunjukkan target standar:

Target Bulanan:
30

Tetapi sistem memberikan dispensasi berdasarkan tanggal mulai.

Jika member bekerja selama 15 hari dan berhasil menyelesaikan 15 pekerjaan:

Target efektif:
15

Realisasi:
15

Achievement:
100%

Payroll dihitung berdasarkan pekerjaan yang benar-benar dilakukan sesuai aturan rate.


## 24. Member Leaving

Member yang berhenti bekerja harus dibuat inactive, bukan langsung dihapus.

Data historis tetap disimpan.

Contoh:

User:
Randi

Status:
inactive

Performance lama:
tetap tersedia

Payroll lama:
tetap tersedia

User inactive tidak dapat melakukan performance submission baru.


## 25. Crew Photography

Crew photography merupakan pekerjaan tambahan.

Crew dicatat oleh Admin.

Input crew dilakukan melalui form:

- Tanggal.
- Nama Member.
- Event.

Satu member dapat menjadi crew untuk beberapa event dalam satu hari.

Karena itu Admin dapat membuat beberapa record crew pada tanggal yang sama.

Contoh:

12 Agustus

Randi
- Event A

Randi
- Event B

Setiap record dapat memiliki compensation sesuai rate crew yang berlaku.

Crew compensation dihitung terpisah dari performance utama.


## 26. Dashboard Architecture

Dashboard tidak boleh menyimpan statistik sebagai angka statis jika angka tersebut dapat dihitung dari data sumber.

Dashboard sebaiknya menghitung atau mengambil agregasi berdasarkan:

- Performance.
- Assignment.
- Payroll.
- Crew Activity.

Contoh statistik:

- Total member aktif.
- Total assignment.
- Total performance.
- Performance completion.
- Achievement rata-rata.
- Total payroll.
- Total pemasukan.
- Total pengeluaran.
- Crew activity.

Jika diperlukan optimasi di masa depan, agregasi dapat disimpan sebagai cached/summary data.


## 27. Audit Log

Audit log digunakan untuk mencatat aktivitas administratif penting.

Aktor:

- Admin.
- Super Admin.

Member tidak memiliki akses ke audit log.

Contoh aktivitas:

- CREATE_ASSIGNMENT
- UPDATE_ASSIGNMENT
- CHANGE_JOBDESK
- CHANGE_RATE
- CREATE_CREW_RECORD
- UPDATE_PAYROLL
- APPROVE_PAYROLL
- MANUAL_ADJUSTMENT
- CREATE_USER
- DISABLE_USER
- CHANGE_ROLE
- CHANGE_PAYROLL_PERIOD
- EMERGENCY_CORRECTION

Audit log minimal menyimpan:

- Actor user ID.
- Actor role.
- Action.
- Target entity.
- Target ID.
- Timestamp.
- Perubahan sebelum/sesudah jika relevan.
- Optional reason/note.

Audit log tidak boleh dapat diedit oleh user biasa.


## 28. Timezone

Seluruh business logic menggunakan:

Asia/Makassar
WITA (UTC+08:00)

Waktu penting seperti:

- Deadline.
- Submission.
- Payroll period.
- Assignment date.
- Crew date.

harus menggunakan timezone WITA.

Jangan menggunakan timezone device secara bebas untuk business logic.


## 29. Deadline Architecture

Deadline ditentukan oleh Admin pada assignment/jobdesk.

Contoh:

08:00 – 23:59

Untuk pekerjaan yang deadline-nya sampai akhir hari:

Deadline:
23:59 WITA

Kategori keterlambatan:

Sampai deadline:
DONE

Setelah deadline sampai +1 jam:
LATE

Lebih dari +1 jam:
VERY_LATE

Jika melewati batas maksimum yang ditentukan sistem:
NOT_DONE

Nilai batas waktu harus disimpan secara konsisten dan tidak boleh bergantung pada waktu lokal device.


## 30. Data Editing Rules

Member tidak dapat mengubah performance yang sudah disubmit secara bebas.

Jika terdapat kesalahan:

Member
↓
Meminta koreksi kepada Admin
↓
Admin melakukan verifikasi
↓
Jika diperlukan, Admin/Super Admin melakukan correction
↓
Audit log dibuat

Untuk koreksi penting setelah data dikunci, Super Admin diperlukan.


## 31. Security Principles

Security harus diterapkan di dua level.

### Application Level

Flutter menentukan UI dan route berdasarkan role.

### Firebase Security Rules

Firebase Security Rules menjadi enforcement utama.

Jangan menganggap:

if (role == admin)

di Flutter sebagai security.

UI restriction hanya untuk UX.

Security Rules harus tetap mencegah user melakukan operasi yang tidak diizinkan.


## 32. Firestore Query Principles

Query harus dibuat efisien.

Hindari:

- Mengambil seluruh collection lalu melakukan filter di Flutter.
- Membaca data yang tidak diperlukan.
- Query berulang dari banyak widget.
- Listener realtime pada data yang tidak membutuhkan realtime.

Gunakan query berdasarkan:

- User ID.
- Assignment ID.
- Tanggal.
- Payroll period.
- Status.
- Role.


## 33. Realtime Data

Data yang membutuhkan update realtime dapat menggunakan Firestore realtime listeners.

Contoh:

- Performance member.
- Dashboard admin.
- Assignment.
- Payroll processing state.

Tidak semua data harus realtime.

Gunakan realtime listener hanya ketika memang memberikan manfaat.


## 34. Error Handling

Semua operasi Firebase harus memiliki error handling.

UI harus memberikan feedback yang jelas.

Contoh state:

- Loading.
- Success.
- Empty.
- Error.

Jangan menampilkan error mentah Firebase kepada user jika tidak diperlukan.

Contoh buruk:

[cloud_firestore/permission-denied] Missing or insufficient permissions.

Contoh baik:

Anda tidak memiliki izin untuk melakukan tindakan ini.

Error teknis tetap dapat dicatat untuk debugging.


## 35. Loading State

Setiap operasi asynchronous harus memiliki state yang jelas.

Minimal:

- Initial.
- Loading.
- Success.
- Error.

Jangan membuat user menekan tombol berkali-kali karena UI tidak memberikan feedback bahwa proses sedang berjalan.

Button untuk operasi penting harus dinonaktifkan selama request berlangsung.


## 36. Offline Consideration

Aplikasi merupakan aplikasi online.

Firebase Firestore offline persistence boleh digunakan sebagai fitur tambahan, tetapi jangan menjadikan offline mode sebagai sumber kebenaran utama untuk business-critical operation.

Jika koneksi tidak tersedia ketika melakukan operasi penting:

User harus mendapatkan feedback bahwa data belum berhasil dikirim.

Payroll dan perubahan administratif penting harus dipastikan tersinkronisasi dengan server sebelum dianggap berhasil.


## 37. File / Folder Structure

Gunakan struktur sederhana:

lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── routing/
│
├── models/
│
├── providers/
│
├── services/
│
├── screens/
│   ├── auth/
│   ├── member/
│   ├── admin/
│   └── super_admin/
│
├── widgets/
│
└── main.dart

Jika suatu feature menjadi cukup besar, folder dapat dikelompokkan berdasarkan feature.

Namun jangan membuat struktur folder yang terlalu dalam tanpa alasan.


## 38. Model Layer

Model digunakan untuk merepresentasikan data Firestore.

Contoh:

- UserModel
- JobdeskModel
- AssignmentModel
- PerformanceModel
- CrewActivityModel
- PayrollPeriodModel
- PayrollModel
- AuditLogModel

Model harus memiliki:

- fromFirestore()
- toFirestore()

atau pola setara yang konsisten.

Jangan mencampurkan logic UI ke dalam model.


## 39. Business Logic Principles

Business logic penting harus berada di provider/service layer, bukan di widget.

Contoh buruk:

- Widget menghitung payroll.
- Widget menentukan status late.
- Widget menentukan achievement.
- Widget menentukan role.

Contoh yang benar:

PerformanceService
→ menentukan performance status.

PayrollService
→ menghitung payroll.

Provider
→ menyediakan hasil ke UI.

Widget
→ menampilkan hasil.


## 40. Calculation Consistency

Perhitungan yang digunakan oleh:

- Dashboard.
- Performance.
- Payroll.
- Report.

harus berasal dari business logic yang sama.

Jangan membuat formula berbeda di setiap halaman.

Jika perhitungan sudah cukup kompleks, dapat dibuat utility/service terpisah seperti:

- AchievementCalculator.
- PayrollCalculator.
- PerformanceStatusCalculator.


## 41. Historical Data Principle

Prinsip paling penting dalam aplikasi:

> Current configuration must not overwrite historical facts.

Contoh:

Rate saat ini berubah
→ Payroll lama tidak berubah.

Jobdesk saat ini berubah
→ Performance lama tidak berubah.

Assignment saat ini berubah
→ Histori performance tetap menggunakan assignment sebelumnya.

Member menjadi inactive
→ Histori tetap tersedia.

Jika suatu data pernah digunakan untuk menghitung payroll, informasi yang relevan harus disimpan sebagai historical snapshot atau referensi immutable.


## 42. V1 Scope

V1 fokus pada:

- Firebase Authentication.
- Role Member/Admin/Super Admin.
- Jobdesk.
- Assignment.
- Daily performance.
- Late/Very Late calculation.
- Achievement.
- Crew photography.
- Payroll.
- Payroll approval.
- Member payroll visibility.
- Audit log.
- Dashboard.
- Histori data.


## 43. Features NOT Required for V1

Jangan mengimplementasikan fitur berikut kecuali diminta:

- Attendance system.
- Automatic assignment generation.
- Automatic task assignment setiap hari.
- Salary deduction otomatis berdasarkan lateness.
- Biometric attendance.
- GPS attendance.
- Employee self-registration.
- Complex chat.
- Push notification.
- Custom backend.
- Complex offline-first architecture.
- AI-based performance evaluation.

Fitur tersebut dapat dipertimbangkan untuk versi berikutnya.


## 44. Development Priority

Implementasi sebaiknya dilakukan bertahap.

### Phase 1 — Project Setup

- Flutter.
- Firebase.
- Firebase Authentication.
- Firestore.
- Riverpod.
- GoRouter.
- Theme.

### Phase 2 — Authentication and Role

- Login.
- Current user.
- Role.
- Route protection.

### Phase 3 — Master Data

- Users.
- Jobdesk.
- Assignment.

### Phase 4 — Performance

- Daily performance.
- Submission.
- Status.
- Achievement.
- History.

### Phase 5 — Crew

- Crew activity.
- Crew compensation.

### Phase 6 — Payroll

- Payroll period.
- Calculation.
- Manual adjustment.
- Approval.
- Member payroll visibility.

### Phase 7 — Administrative

- Audit log.
- Super Admin controls.
- Historical correction.

### Phase 8 — Dashboard and Polishing

- Statistics.
- Reports.
- UI refinement.
- Error handling.
- Performance optimization.


## 45. Source of Truth Rule for AI Agent

AI Agent wajib membaca dokumen berikut sebelum melakukan perubahan arsitektur atau implementasi besar:

docs/PRD.md
docs/ARCHITECTURE.md
docs/DATABASE_SCHEMA.md
docs/DESIGN.md
docs/RULES.md

Prioritas keputusan:

PRD
↓
ARCHITECTURE
↓
DATABASE_SCHEMA
↓
DESIGN
↓
RULES
↓
Implementation

Jika terdapat konflik antar dokumen, AI Agent tidak boleh memilih secara diam-diam.

AI Agent harus:

1. Mendeteksi konflik.
2. Menjelaskan konflik.
3. Memilih solusi yang paling aman hanya jika perubahan tersebut tidak mengubah business rule.
4. Meminta keputusan manusia jika konflik memengaruhi business rule.


## 46. Core Architectural Principle

Aplikasi harus mengikuti prinsip:

Simple architecture
+
Strong data integrity
+
Historical transparency
+
Role-based security
+
Centralized business logic
+
Firebase as source of truth

Jangan menambahkan kompleksitas hanya karena teknologi tersebut tersedia.

Setiap architectural decision harus memiliki alasan yang jelas dan harus mendukung kebutuhan aplikasi.