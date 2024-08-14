<template>
  <div class="home">
    <h1>Selamat Datang di Beranda</h1>
    <p>Ini adalah halaman utama aplikasi kami.</p>
    <p>{{ currentTime }}</p> <!-- Menampilkan waktu real-time -->
  </div>
</template>

<script>
export default {
  data() {
    return {
      currentTime: this.getCurrentTime()
    };
  },
  mounted() {
    this.updateTime();
  },
  methods: {
    getCurrentTime() {
      const now = new Date();
      const options = { 
        weekday: 'long', 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric', 
        hour: '2-digit', 
        minute: '2-digit', 
        second: '2-digit', 
        hour12: false 
      };
      return now.toLocaleDateString('id-ID', options);
    },
    updateTime() {
      setInterval(() => {
        this.currentTime = this.getCurrentTime();
      }, 1000);
    }
  }
};
</script>

<style scoped>
.home {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 85vh;
  text-align: center;
  background-image: url('../assets/css/logo.png'); /* Ganti dengan path gambar Anda */
  background-position: 100% 35%; /* Agar gambar berada di tengah */
  background-repeat: no-repeat; /* Agar gambar tidak diulang */
  background-color: #f0f4f8; /* Warna latar belakang */
  
}

h1 {
  color: #333; /* Warna teks untuk judul */
  font-family: 'Arial', sans-serif; /* Font untuk judul */
}

p {
  color: #666; /* Warna teks untuk paragraf */
  font-family: 'Verdana', sans-serif; /* Font untuk paragraf */
}


</style>