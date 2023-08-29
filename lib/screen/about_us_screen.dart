import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    const textSpan = TextSpan(
      children: [
        TextSpan(
          text: 'Tentang ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: 'Kami',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xffFE0002),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text.rich(textSpan),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset('assets/about_bitread.png', width: 120, height: 120),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      'BITREAD adalah sebuah gerakan untuk menerbitkan buku secara swadaya (self publishing). Siapapun bisa menerbitkan bukunya melalui BITREAD. Selain sebagai penerbit yang pro terhadap tumbuhnya kualitas dan kuantitas literasi di Indonesia, BITREAD juga sebagai wadah bagi penulis untuk menerbitkan buku. Tidak hanya untuk penulis profesional namun juga untuk penulis pemula yang ingin karyanya terbit menjadi buku.\n\nBITREAD juga mengelola distribusi buku-buku terbitan penulis dengan menyediakan platform serta jaringan toko buku digital. Sehingga penulis, siapapun ia akan menjadi lebih mudah menerbitkan bukunya dan terhubung dengan segmen pembacanya. BITREAD adalah Self Publishing yang mempunyai 2 opsi, yaitu VERSI DIGITAL dan VERSI CETAK.\n\nKini Bitread memberikan layanan lain kepada para penulis dan masyarakat Indonesia secara luas. Yakni dengan kehadiran Bitjournal Media dan akademi literasi Academy Bitread.\n\nBitjournal merupakan wadah menulis yang hadir dalam bentul platform media informasi. Sedangkan Academy Bitread adalah platform pelatihan daring yang menjadi sarana bagi para penulis bitread untuk membuat kelas dan memberikan pelatihan daring. Melalui kelas di akademi tujuan akhirnya adalah mengarahkan para peserta untuk mendapatkan keahlian tambahan dan menuliskan apa yang mereka dapatkan ketika belajar. Hasil tulisannya akan dimuat di Bitjournal dan dibukukan di Bitread Publishing.\n\nUntuk menguatkan kegiatan literasi di Indonesia, Bitread juga memiliki program khusus yang bernama WRITINGTHON.\n\nKesungguhan Bitread dalam mengembangkan literasi di Indonesia dimunculkan pula pada  kegiatan pengembangan literasi lainnya yang dibangun di titik-titik pendidikan dan komunitas masyarakat, seperti satu sekolah satu buku, hilirisasi riset, dan kerjasama komunitas dapat dilihat di Bitread TV',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text('Ikuti Kami di: '),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final url = Uri.parse(
                                'https://instagram.com/bitread_id?igshid=OGQ5ZDc2ODk2ZA==');
                            await launchUrl(url);
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/instagram.png',
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(height: 10),
                              const Text('Instagram'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final url = Uri.parse(
                                'https://www.tiktok.com/@bitread_id?_t=8fEd8oU10zq&_r=1');
                            await launchUrl(url);
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  'assets/tiktok.png',
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text('Tiktok'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
