# Product Requirements Document (PRD)

## Silent Memory — Team Performance & Payroll Management App

**Version:** 1.0
**Status:** Draft / MVP
**Timezone:** WITA (UTC+8)

---

# 1. Product Overview

Silent Memory Team Management App adalah aplikasi internal untuk mengelola kinerja, assignment pekerjaan, data crew, payroll, dan informasi terkait tim Silent Memory.

Aplikasi dibuat untuk menggantikan pencatatan kinerja manual menggunakan spreadsheet yang saat ini membutuhkan banyak input dan pengelolaan manual.

Sistem akan mencatat pekerjaan berdasarkan input aktual dari member setiap hari. Member bertanggung jawab mencatat pekerjaan yang telah mereka lakukan, sedangkan Admin bertanggung jawab mengatur assignment, melakukan review, mengelola payroll, dan mengelola data operasional.

Aplikasi bersifat online dan menggunakan Firebase sebagai backend utama sehingga data dapat diakses secara real-time oleh pengguna yang memiliki akun.

---

# 2. Problem Statement

Sistem pencatatan saat ini memiliki beberapa masalah:

* Pencatatan kinerja dilakukan secara manual di spreadsheet.
* Status pekerjaan harus diperiksa dan diubah secara manual.
* Perhitungan jumlah pekerjaan, achievement, dan gaji membutuhkan banyak formula spreadsheet.
* Data kinerja dan data payroll terpisah sehingga sulit dipantau.
* Kesalahan input dapat terjadi ketika Admin mengubah data secara manual.
* Riwayat perubahan data sulit dilacak.
* Penambahan atau pengurangan jobdesk dapat memengaruhi banyak perhitungan lain.
* Data crew pemotretan harus dicatat secara terpisah.
* Dibutuhkan akses data secara real-time bagi pihak yang berwenang.

Aplikasi ini bertujuan membuat proses tersebut lebih terstruktur, transparan, dan otomatis.

---

# 3. Goals

## 3.1 Primary Goals

1. Menggantikan tracker kinerja manual berbasis spreadsheet.
2. Member memungkinkan mencatat pekerjaan mereka sendiri.
3. Admin dapat memantau kinerja seluruh member secara real-time.
4. Sistem otomatis menghitung realisasi dan achievement.
5. Sistem otomatis menghitung gaji berdasarkan realisasi pekerjaan.
6. Sistem dapat mencatat pekerjaan tambahan sebagai crew pemotretan.
7. Sistem menyediakan proses payroll yang terstruktur.
8. Sistem menyimpan riwayat perubahan penting melalui audit log.
9. Sistem membatasi akses berdasarkan role.
10. Sistem menyediakan laporan kinerja dan payroll yang dapat dicetak.

## 3.2 Secondary Goals

* Mengurangi pekerjaan administratif.
* Mengurangi risiko kesalahan perhitungan.
* Meningkatkan transparansi pencatatan pekerjaan.
* Menyediakan dasar untuk pengembangan sistem penalty dan automation di masa depan.

---

# 4. Non-Goals for MVP

Fitur berikut tidak menjadi prioritas versi 1.0:

* Sistem absensi/attendance.
* Automatic assignment generation.
* Pemotongan gaji otomatis berdasarkan keterlambatan.
* Sistem bonus otomatis.
* Integrasi langsung dengan sistem keuangan eksternal.
* Member membuat akun sendiri.
* Upload bukti foto sebagai kewajiban setiap pekerjaan.
* Integrasi transaksi keuangan dengan aplikasi.

Data transaksi keuangan tetap dapat dikelola melalui spreadsheet untuk MVP.

---

# 5. User Roles

Aplikasi memiliki tiga role utama.

## 5.1 Super Admin

Super Admin memiliki hak akses tertinggi.

Responsibilities:

* Mengelola akun pengguna.
* Menambah member baru.
* Menonaktifkan member.
* Mengubah role pengguna.
* Mengubah konfigurasi penting.
* Mengubah data yang sudah di-approve oleh Admin.
* Mengubah payroll period.
* Melakukan koreksi urgent.
* Mengakses audit log.
* Memiliki seluruh akses Admin.

Super Admin digunakan terutama untuk perubahan penting atau kondisi khusus, bukan untuk operasional harian.

---

## 5.2 Admin

Admin bertanggung jawab atas operasional harian.

Responsibilities:

* Mengatur assignment/jobdesk.
* Mengatur target jobdesk.
* Mengatur jam mulai dan deadline.
* Mengatur apakah member memiliki tugas pada hari tertentu.
* Melihat kinerja seluruh member.
* Review data kinerja.
* Mengelola crew pemotretan.
* Membuka dan memproses payroll.
* Menyetujui payroll.
* Memberikan bonus atau potongan manual.
* Mencetak laporan kinerja.
* Mencetak laporan payroll.

Admin tidak dapat mengubah data yang telah dikunci/approved jika perubahan tersebut membutuhkan hak Super Admin.

---

## 5.3 Member

Member adalah pengguna yang mengerjakan pekerjaan dan mencatat hasil pekerjaannya sendiri.

Member dapat:

* Login menggunakan akun yang diberikan.
* Melihat assignment miliknya.
* Melihat jobdesk miliknya.
* Mengisi hasil pekerjaan harian.
* Mengisi pekerjaan yang dilakukan pada hari sebelumnya.
* Melihat riwayat pekerjaan pribadi.
* Melihat ringkasan kinerja pribadi.

Member tidak dapat:

* Mengubah assignment.
* Mengubah target.
* Mengubah payroll.
* Melihat gaji sebelum payroll selesai/approved.
* Melihat data kinerja member lain.
* Mengubah data milik member lain.
* Mengakses audit log.

---

# 6. Authentication

Authentication menggunakan Firebase Authentication.

Akun dibuat oleh Super Admin.

Member tidak melakukan registrasi secara bebas.

Flow:

1. Super Admin membuat akun.
2. Sistem membuat akun Firebase Authentication.
3. Super Admin memberikan email/username dan password kepada member.
4. Member login menggunakan akun tersebut.
5. Role pengguna disimpan dan digunakan untuk menentukan permission.

Sistem harus menggunakan role-based access control.

---

# 7. Assignment & Jobdesk System

Assignment merupakan pekerjaan yang harus dilakukan oleh member.

Contoh:

* Up Story
* Up Postingan Project
* Up Konten
* Monitoring Social Media
* Update Spreadsheet
* CS
* Editing Project
* Send Results Edit
* Research Konten
* Konten Crafting
* Send Konten
* Shooting

Assignment dibuat dan dikelola oleh Admin.

---

# 8. Assignment Configuration

Setiap assignment memiliki konfigurasi:

* Nama jobdesk
* Kode jobdesk
* Member yang memiliki assignment
* Target
* Rate/upah per pekerjaan
* Jam mulai
* Deadline
* Status aktif/nonaktif
* Kategori assignment
* Jenis assignment

Assignment tidak dibuat dengan menentukan seluruh tanggal kerja satu per satu.

Sebagai contoh:

Member memiliki target:

`Up Story — 30 pekerjaan/bulan`

Secara default pekerjaan tersebut tersedia untuk dikerjakan setiap hari selama periode kerja.

Admin dapat menentukan bahwa pada hari tertentu member tidak memiliki tugas.

---

# 9. Daily Assignment Status

Untuk setiap assignment pada suatu tanggal, sistem dapat memiliki status:

* `NOT_ASSIGNED`
* `ASSIGNED`
* `COMPLETED`
* `LATE`
* `VERY_LATE`
* `NOT_DONE`

`NOT_ASSIGNED` berarti pada hari tersebut pekerjaan memang tidak diberikan kepada member.

`NOT_DONE` berarti pekerjaan seharusnya dikerjakan tetapi member tidak menyelesaikannya.

Kedua kondisi tersebut harus dibedakan.

---

# 10. Member Performance Submission

Member mengisi kinerja mereka sendiri.

Pada halaman input kinerja:

1. Sistem otomatis menggunakan tanggal hari ini.
2. Member dapat memilih tanggal hari ini atau tanggal sebelumnya.
3. Member tidak dapat memilih tanggal masa depan.
4. Member memilih/menandai pekerjaan yang telah dilakukan.
5. Member dapat memberikan optional note.
6. Member dapat menyimpan submission.

Contoh:

Tanggal:

`12 August 2026`

Jobdesk:

`Up Story`

Status:

`Completed`

Note:

`Story promo event`

---

# 11. Backdated Submission

Member diperbolehkan mengisi pekerjaan untuk tanggal sebelumnya.

Contoh:

Member lupa mengisi pekerjaan tanggal 10 Agustus.

Pada tanggal 11 Agustus, member dapat memilih:

`10 August 2026`

dan melakukan submission.

Sistem akan mendeteksi bahwa submission dilakukan setelah tanggal kerja tersebut dan menyimpan informasi keterlambatan input.

Member tidak dapat memilih tanggal masa depan.

---

# 12. Performance Status Calculation

Status pekerjaan berdasarkan waktu submission.

Contoh konfigurasi:

### On Time

Jam kerja:

`08:00 - 23:59`

Jika pekerjaan diselesaikan pada periode tersebut:

`COMPLETED`

### Late

Setelah deadline hingga 1 jam:

`00:00 - 00:59`

Status:

`LATE`

### Very Late

Lebih dari 1 jam setelah deadline sampai batas tertentu:

`01:00 - 04:59`

Status:

`VERY_LATE`

### Not Done

Jika melewati batas waktu yang ditentukan tanpa submission:

`NOT_DONE`

Konfigurasi waktu dapat dibuat fleksibel oleh Admin.

---

# 13. Performance Achievement

Realisasi dan achievement merupakan dua hal berbeda.

## Realisasi

Realisasi menghitung berapa kali pekerjaan benar-benar dibuat/diselesaikan.

Contoh:

Target:

`30`

Realisasi:

`25`

Maka:

`25 / 30`

## Achievement

Achievement mempertimbangkan kualitas ketepatan waktu.

Untuk MVP:

* Completed / On Time = `1.00`
* Late = `0.75`
* Very Late = `0.50`
* Not Done = `0.00`

Contoh:

10 pekerjaan:

* 7 on time
* 2 late
* 1 very late

Achievement:

`(7 × 1.00 + 2 × 0.75 + 1 × 0.50) / 10`

Achievement tidak mengurangi gaji pada MVP.

---

# 14. Payroll Calculation

Gaji utama dihitung berdasarkan realisasi pekerjaan.

Achievement digunakan sebagai indikator kinerja, tetapi belum menjadi faktor pengurang gaji.

Contoh:

Rate:

`Rp6.000/job`

Realisasi:

`25`

Gaji:

`25 × Rp6.000 = Rp150.000`

Jika achievement hanya 80%, gaji tetap:

`Rp150.000`

Sistem dapat menampilkan achievement sebagai informasi evaluasi.

Pada masa depan, sistem dapat menggunakan achievement untuk penalty/pemotongan gaji jika bisnis sudah lebih besar.

---

# 15. Target Changes

Target assignment dapat berubah berdasarkan kesepakatan.

Sistem harus menyimpan histori perubahan target.

Contoh:

Target awal:

`30`

Kemudian diubah menjadi:

`20`

Kemudian diubah lagi menjadi:

`15`

Sistem tetap menyimpan bahwa member telah menyelesaikan:

`20 pekerjaan`

Jika target aktif terakhir adalah 15:

`Realisasi historis: 20`

`Target aktif: 15`

`Achievement terhadap target aktif: 20/15`

Perubahan target tidak boleh menghapus histori realisasi.

Perubahan target harus dicatat dalam audit/history.

---

# 16. New Member & Prorated Target

Member baru mulai bekerja pada tanggal tertentu.

Contoh:

Member masuk tanggal 15.

Assignment normal:

`30 pekerjaan/bulan`

Karena member hanya aktif selama 15 hari, sistem memberikan prorated target:

`15 pekerjaan`

Member dianggap mencapai 100% achievement jika menyelesaikan 15 pekerjaan dalam periode tersebut.

Gaji dihitung berdasarkan pekerjaan aktual yang dilakukan.

---

# 17. Assignment Change After Performance Submission

Jika member telah melakukan pekerjaan dan Admin kemudian mengubah status assignment menjadi `NOT_ASSIGNED`, sistem tidak boleh menghapus histori pekerjaan member.

Contoh:

Member mengerjakan:

`Up Story — 12 Agustus`

Member melakukan submission.

Kemudian malam hari Admin mengubah assignment tanggal 12 menjadi:

`NOT_ASSIGNED`

Maka:

* Submission member tetap tersimpan.
* Histori pekerjaan tetap tersimpan.
* Realisasi tetap mencatat pekerjaan tersebut.
* Gaji tetap dihitung berdasarkan pekerjaan tersebut.
* Perubahan assignment dicatat dalam audit log.
* Admin tidak boleh menghapus histori secara diam-diam.

Tujuannya adalah menjaga transparansi antara pekerjaan yang sudah dilakukan dan perubahan assignment setelahnya.

---

# 18. Photography Crew / Additional Work

Pekerjaan sebagai crew pemotretan merupakan pekerjaan tambahan.

Pada halaman input kinerja terdapat bagian:

`Menjadi crew hari ini?`

Pilihan:

* Ya
* Tidak

Jika `Ya`, muncul field:

`Event`

Jika `Tidak`, field event tidak ditampilkan.

Namun karena satu member dapat menjadi crew pada lebih dari satu event dalam satu hari, sistem juga menyediakan fitur khusus `Daily Crew Activity`.

Admin dapat memasukkan:

* Tanggal
* Nama member
* Nama event

Data tersebut dapat dibuat lebih dari satu kali dalam satu tanggal.

Contoh:

12 Agustus:

* Randi — Event A
* Randi — Event B
* Ica — Event A

Setiap aktivitas crew memiliki rate sesuai konfigurasi payroll.

Crew merupakan tambahan dari gaji utama.

---

# 19. Payroll Period

Payroll menggunakan periode yang dapat ditentukan oleh Admin.

Contoh:

`1 June — 15 July`

Maka sistem menghitung seluruh kinerja dalam periode tersebut.

Payroll period tidak harus selalu sama dengan kalender satu bulan.

Super Admin dapat mengubah atau memperpanjang payroll period jika diperlukan.

Perubahan payroll period harus tercatat dalam audit log.

---

# 20. Payroll State

Payroll memiliki lifecycle.

Contoh:

`DRAFT`

→ `REVIEW`

→ `APPROVED`

→ `COMPLETED`

Sebelum payroll selesai/approved:

* Member tidak dapat melihat nominal gaji.
* Admin dapat melakukan review.
* Sistem menghitung gaji berdasarkan data kinerja.

Setelah payroll approved/completed:

* Nominal gaji dapat dilihat oleh member untuk periode tersebut.
* Data payroll dikunci.
* Perubahan setelah locking membutuhkan hak Super Admin.

---

# 21. Manual Bonus & Deduction

Admin dapat memberikan:

* Bonus manual
* Potongan manual

Data harus memiliki:

* Nominal
* Jenis
* Alasan/catatan
* Pembuat perubahan
* Waktu perubahan

Potongan manual tidak berasal dari achievement pada MVP.

---

# 22. Salary Visibility

Member tidak dapat melihat nominal gaji berjalan.

Member hanya dapat melihat:

* Status payroll
* Payroll period
* Gaji setelah payroll selesai/approved

Tujuannya agar member fokus pada pekerjaan dan tidak menjadikan nominal gaji berjalan sebagai fokus utama selama periode kerja.

---

# 23. Performance Reports

Admin dapat melihat laporan kinerja seluruh member.

Laporan minimal berisi:

* Nama member
* Periode
* Jobdesk
* Target
* Realisasi
* Jumlah on time
* Jumlah late
* Jumlah very late
* Jumlah not done
* Achievement
* Persentase pencapaian
* Total pekerjaan
* Total pekerjaan tambahan/crew

Laporan dapat dicetak.

---

# 24. Member Performance Page

Member dapat melihat kinerja pribadi.

Informasi:

* Periode
* Assignment
* Target
* Realisasi
* Achievement
* On time
* Late
* Very late
* Not done
* Riwayat pekerjaan

Member tidak dapat melihat data member lain.

---

# 25. Admin Dashboard

Admin Dashboard menampilkan ringkasan operasional.

Minimal:

* Total member aktif
* Total assignment
* Performance hari ini
* Pekerjaan selesai
* Late
* Very late
* Not done
* Ringkasan achievement
* Status payroll
* Crew activity

Dashboard harus menggunakan data real-time.

---

# 26. Super Admin Dashboard

Super Admin memiliki seluruh informasi Admin ditambah:

* User management
* Role management
* System configuration
* Payroll period configuration
* Audit log
* Emergency correction
* Data modification history

---

# 27. Audit Log

Audit log mencatat perubahan penting.

Contoh aktivitas:

* Login
* Membuat member
* Menonaktifkan member
* Mengubah role
* Membuat assignment
* Mengubah assignment
* Mengubah target
* Mengubah status assignment
* Mengubah payroll period
* Memberikan bonus
* Memberikan potongan
* Mengubah payroll
* Approve payroll
* Perubahan data setelah approval

Audit log minimal menyimpan:

* Actor
* Role actor
* Action
* Data yang diubah
* Nilai sebelum
* Nilai sesudah
* Timestamp
* Reference ID

Audit log hanya dapat diakses oleh Super Admin.

---

# 28. Transparency & Data Integrity

Prinsip utama sistem:

> Data kinerja harus berasal dari aktivitas yang benar-benar dilakukan dan submission yang dilakukan member.

Admin tidak boleh mengubah histori pekerjaan secara sembarangan untuk memengaruhi kinerja member.

Perubahan administratif tetap diperbolehkan, tetapi harus memiliki histori.

Data yang telah digunakan dalam payroll approved tidak boleh diubah oleh Admin.

Perubahan setelah approval membutuhkan Super Admin dan harus tercatat di audit log.

---

# 29. Real-Time Data

Firebase digunakan sebagai backend utama.

Data utama harus tersinkronisasi secara real-time, terutama:

* Assignment
* Performance submission
* Performance summary
* Crew activity
* Payroll status
* User status

---

# 30. Core Application Modules

MVP minimal memiliki modul:

1. Authentication
2. Dashboard
3. Assignment / Jobdesk
4. Daily Performance
5. Performance History
6. Crew Activity
7. Performance Report
8. Payroll
9. User Management
10. Audit Log
11. Settings / Configuration

---

# 31. Suggested Navigation

## Member

* Dashboard
* My Performance
* Daily Performance
* History
* Profile

## Admin

* Dashboard
* Performance
* Assignments
* Crew Activity
* Payroll
* Reports
* Profile

## Super Admin

* Dashboard
* Performance
* Assignments
* Crew Activity
* Payroll
* Reports
* User Management
* Audit Log
* System Settings
* Profile

---

# 32. Data Architecture Requirements

Backend menggunakan Firebase.

Komponen yang direncanakan:

* Firebase Authentication
* Cloud Firestore
* Firebase Security Rules

Data harus dipisahkan berdasarkan entity sehingga perubahan satu entity tidak merusak data entity lainnya.

Contoh entity utama:

* users
* assignments
* assignment_history
* daily_performance
* crew_activities
* payroll_periods
* payroll_records
* payroll_adjustments
* audit_logs

Struktur database detail akan ditentukan pada dokumen `Schema.md`.

---

# 33. Security Requirements

Sistem harus menerapkan role-based authorization.

Member tidak boleh:

* Membaca data member lain.
* Mengubah assignment.
* Mengubah payroll.
* Mengubah role.
* Mengakses audit log.

Admin tidak boleh:

* Mengubah role.
* Mengelola akun pengguna.
* Mengubah data yang sudah locked jika membutuhkan Super Admin.
* Menghapus audit log.

Super Admin memiliki akses penuh sesuai kebutuhan sistem.

Firebase Security Rules harus menjadi lapisan keamanan utama, bukan hanya pengecekan role di Flutter UI.

---

# 34. Timezone

Seluruh sistem menggunakan:

`Asia/Makassar (WITA / UTC+8)`

Waktu submission, deadline, payroll period, dan audit log harus konsisten menggunakan timezone tersebut.

---

# 35. MVP Success Metrics

MVP dianggap berhasil jika:

1. Member dapat login.
2. Member dapat melihat assignment miliknya.
3. Member dapat menginput pekerjaan hari ini.
4. Member dapat menginput pekerjaan tanggal sebelumnya.
5. Member tidak dapat menginput tanggal masa depan.
6. Sistem dapat menentukan status pekerjaan berdasarkan waktu.
7. Sistem dapat menghitung realisasi.
8. Sistem dapat menghitung achievement.
9. Sistem dapat menghitung gaji utama.
10. Sistem dapat menghitung tambahan crew.
11. Admin dapat melihat kinerja seluruh member secara real-time.
12. Admin dapat membuat dan mengubah assignment.
13. Admin dapat mengatur hari `NOT_ASSIGNED`.
14. Super Admin dapat mengelola akun.
15. Super Admin dapat mengakses audit log.
16. Payroll dapat dibuat dan di-approve.
17. Member hanya dapat melihat gaji setelah payroll selesai.
18. Data payroll yang sudah approved dapat dikunci.
19. Sistem menyimpan histori perubahan penting.

---

# 36. Future Development

Fitur yang dapat dikembangkan setelah MVP:

* Automatic assignment generation.
* Automatic prorated assignment generation.
* Automatic penalty berdasarkan achievement.
* Minimum achievement requirement.
* Bonus otomatis.
* Upload bukti pekerjaan.
* Push notification.
* Reminder pekerjaan.
* Notification pekerjaan terlambat.
* Analytics performa yang lebih kompleks.
* Integrasi sistem keuangan.
* Export laporan ke PDF/Excel.
* Multi-team support.
* Multi-branch support.

---

# 37. Product Principles

Pengembangan aplikasi harus mengikuti prinsip berikut:

1. **Transparency First**
   Histori pekerjaan tidak boleh hilang hanya karena perubahan administratif.

2. **Member-Owned Performance Input**
   Member bertanggung jawab mencatat pekerjaan yang mereka lakukan.

3. **Admin-Owned Operations**
   Admin bertanggung jawab mengatur assignment dan operasional.

4. **Super Admin for Critical Changes**
   Perubahan sensitif dilakukan oleh Super Admin.

5. **Realization Determines Current Pay**
   Pada MVP, gaji utama berdasarkan realisasi pekerjaan.

6. **Achievement Measures Performance Quality**
   Achievement digunakan untuk evaluasi dan bukan pemotongan gaji pada MVP.

7. **History Must Be Preserved**
   Perubahan target, assignment, payroll, dan data penting harus memiliki histori.

8. **Future-Proof Architecture**
   Struktur aplikasi harus memungkinkan sistem penalty dan automation ditambahkan tanpa membangun ulang seluruh aplikasi.

---

# 38. MVP Boundary

Versi 1.0 harus fokus pada:

**Member → melakukan pekerjaan → member mencatat pekerjaan → sistem menentukan status → sistem menghitung realisasi & achievement → Admin melakukan review → sistem menghitung payroll → Admin approve → member dapat melihat hasil payroll.**

Super Admin digunakan untuk:

**User management → konfigurasi penting → koreksi urgent → perubahan setelah approval → audit.**

Sistem tidak perlu memaksakan automation yang belum dibutuhkan pada MVP.
