import 'package:flame/components.dart';

class TextAssets{
  static const dOpening = "Selamat datang pada Petualangan kitab suci. Kamu adalah seorang petualang yang mendapat misi untuk menemukan kitab-kitab Allah dan mempelajari isinya. Setiap kitab memiliki pesan penting yang akan kamu pelajari. Apakah Kamu Siap?";

  static const dKnowledge = {
    "Kitab Taurat":[
      {
        "align": Anchor.topCenter,
        "label":"kitab Taurat di wahyukan kepada Nabi Musa As. untuk berdakwah kepada Bnai Israil. Kitab Taurat diwahyukan dibukit Tursina pada abad 12 SM dalam Bahasa Ibrani. Kata Taurat sendiri memiliki makna hukum atau syariat. oleh karena itu isi kitab adalah aturan-aturan tentang beribadah kepada Allah swt dan menjauhi perbuatan keji dan mungkar.",
      },
      {
        "align": Anchor.topLeft,
        "label":
"""
Pokok-pokok Ajaran:
- Perintah untuk mengesakan Allah
- Larangan menyembah patung/berhala
- Larangan menyebut nama Allah Swt dengan sia-sia
- Perintah menyucikan hari sabtu
- Perintah menghormati orangtua
- Larangan membunuh sesama manusia
- Larangan berbuat zina
- Larangan mencuri, menjadi saksi palsu, dan mengambil hak orang lain
""",
      },
      {
        "align": Anchor.topCenter,
        "label": "Setelah mempelajari materi tentang taurat. apakah kamu siap untuk melakukan permainan?"
      }
    ],
    "Kitab Zabur":[
      {
        "align": Anchor.topCenter,
        "label":"Kitab zabur diwahyukan kepada Nabi Daud As. pada abad ke 10 SM, di Yarussalem dlam bahasa Qibti. Kitab abur diwahyukan untuk berdakwah kepada Bani Israil. Kitab zabur berisi ayat-ayat yang dianggap suci, didalamnya tidak mengandung hukum-hukum, tapi hanya nasihat-nasihat, hikmah, pujian, dan sanjungan kepada Allah Swt.",
      },
      {
        "align": Anchor.topLeft,
        "label":
"""
Pokok-pokok Ajaran:
- Nyanyian memuji Tuhan
- Nyanyian perorangan sebagai ucapan syukur
- Ratapan-ratapan jamaah
- Ratapan dan doa individu
- Nyanyian untuk raja.
""",
      },
      {
        "align": Anchor.topCenter,
        "label": "Setelah mempelajari materi tentang zabur. apakah kamu siap untuk melakukan permainan?"
      }
    ],
    "Kitab Injil":[
      {
        "align": Anchor.topCenter,
        "label":"Kitab injil diwakyukan kepada Nabi Isa As. pada awal abad 1M di Yarusalem dengan bahasa suryani. kitab ini merupakan kitab yang dijadikan pedoman bagi kaum nasrani.",
      },
      {
        "align": Anchor.topLeft,
        "label":
"""
Pokok-pokok Ajaran:
- Perintah untuk kembali mengesakan Allah Swt
- Membenarkan keberadaan kitab Taurat
- Menghapus hukum dalam kitab taurat yang tidak lagi sesuai dengan perkembangan zaman
- Penjelasan tentang munculnya nabi yang memiliki sifat mulia, syariat lebih sempurna, dan tidak terbatas oleh waktu dan tempat yakni nabi Muhammad SAW. 
""",
      },
      {
        "align": Anchor.topCenter,
        "label": "Setelah mempelajari materi tentang injil. apakah kamu siap untuk melakukan permainan?"
      }
    ],
    "Kitab Al-Qur'an":[
      {
        "align": Anchor.topCenter,
        "label":"Al-Qur’an diwahyukan kepada Nabi Muhammad Saw pada abad ke 6 M, Selama kurun waktu 22 tahun 2 bulan 22 hari, dikota mekah dan madinah. Alqur’an diwahyukan Allah kepada Rasulullah secara berangsur-angsur melalui malaikat jibril dan membacanya merupakan ibadah. yang terdiri dari 30 juz, 114 surat dan 6236 ayat",
      },
      {
        "align": Anchor.topLeft,
        "label":
"""
Pokok-pokok Ajaran:
- Aqidah (berkaitan dengan keyakinan,seperti mengesakan Allah SWT)
- Akhlak(pembinaan akhlak mulia dan menghindari perbuatan tercela)
- Ibadah (berkaitan dengan tatacara beribadah: shalat,zakat, dll)
- Muamalah (tatacra berhubungan dengan sesama manusia)
- Tarikh (kisah orang-orang dan umat terdahulu)
""",
      },
      {
        "align": Anchor.topCenter,
        "label": "Setelah mempelajari materi tentang taurat. apakah kamu siap untuk melakukan permainan?"
      }
    ]
  };

  static const dQuestion = {
    "Kitab Taurat":[
      {
        "question": "Kepada Siapakah kitab Taurat diturunkan?",
        "options": ["Nabi Isa", "Nabi Daud", "Nabi Musa", "Nabi Muhammad"],
        "answer": "Nabi Musa",
        "true_score": 24,
        "false_score": 5
      },
      {
        "question": "Kitab taurat adalah kitab yang berlaku pada tahun 6 SM dan menggunakan bahasa....",
        "options": ["Qibti", "Ibrani", "Suryani", "Arab"],
        "answer": "Ibrani",
        "true_score": 24,
        "false_score": 5
      },
      {
        "question": "Dibawah Ini yang merupakan BUKAN pokok ajaran dalam kitab taurat adalah",
        "options": ["Larangan menyembah patung/berhala", "Perintah untuk mengesakan Allah", "Perintah menyucikan hari sabtu", "Nyanyian memuji tuhan"],
        "answer": "Nyanyian memuji tuhan",
        "true_score": 24,
        "false_score": 5
      }
    ],
    "Kitab Zabur":[
      {
        "question": "Kepada Siapakah kitab Zabur diturunkan?",
        "options": ["Nabi Isa", "Nabi Daud", "Nabi Musa", "Nabi Muhammad"],
        "answer": "Nabi Daud",
        "true_score": 18,
        "false_score": 5
      },
      {
        "question": "Kitab Zabur merupakan kitab yang berisi puji-pujian, nyanyian, dan laion-lain. kitab tersebut berlaku pada tahun...",
        "options": ["10 SM", "20 SM", "15 SM", "25 SM"],
        "answer": "10 SM",
        "true_score": 18,
        "false_score": 5
      },
      {
        "question": "Dibawah Ini yang merupakan pokok ajaran dalam kitab Zabur adalah",
        "options": ["Ratapan-ratapan jamaah", "Larangan Mencuri", "Perintah mengesakan Allah", "Perintah menghormati orang tua"],
        "answer": "Ratapan-ratapan jamaah",
        "true_score": 22,
        "false_score": 5
      }
    ],
    "Kitab Injil":[
      {
        "question": "Kepada Siapakah kitab Injil diturunkan?",
        "options": ["Nabi Isa", "Nabi Daud", "Nabi Musa", "Nabi Muhammad"],
        "answer": "Nabi Isa",
        "true_score": 24,
        "false_score": 5
      },
      {
        "question": "Salah satu pokok ajaran dalam kitab Injil adalah akan datangnya seorang nabi pembawa rahmat bagi semesta alam. Adapun nabi tersebut ialah",
        "options": ["Isa AS", "Daud AS", "Sulaiman AS", "Muhammad SAW"],
        "answer": "Muhammad SAW",
        "true_score": 24,
        "false_score": 5
      },
      {
        "question": "Kitab injil diturunkan sebagai pelengkap kitab sebelumnya yakni ....",
        "options": ["Zabur", "Taurat", "Al-Qur'an", "Nuzulul Qur'an"],
        "answer": "Taurat",
        "true_score": 24,
        "false_score": 5
      }
    ],
    "Kitab Al-Qur'an":[
      {
        "question": "Kepada Siapakah kitab Al-Qur’an diturunkan?",
        "options": ["Nabi Isa", "Nabi Daud", "Nabi Musa", "Nabi Muhammad"],
        "answer": "Nabi Muhammad",
        "true_score": 11,
        "false_score": 5
      },
      {
        "question": "Al-qur’an diturunkan secara berangsung-angsur. berapa lama kurun waktu diturunkannya Al-Qur’an?",
        "options": ["22 tahun 2 bulan 22 hari", "222 tahun 2 bulan 22 hari", "2 tahun 2 bulan 22 hari", "22 tahun 22 bulan 22 hari"],
        "answer": "22 tahun 2 bulan 22 hari",
        "true_score": 11,
        "false_score": 5
      },
      {
        "question": "Pokok Ajaran yang terdapat dalam Al-Qur’an salah satunya adalah muamalah yang berkaitan dengan ...",
        "options": ["Mengesakan Allah", "Berhubungan dengan sesama", "Menghindari perbuatan tercela", "Tatacara ibadah"],
        "answer": "Berhubungan dengan sesama",
        "true_score": 11,
        "false_score": 5
      }
    ]
  };

  static const dialogCharaPick = [
    "Yeay, terimakasih telah memilihku!",
    "Ayo kita mulai!"
  ];
}