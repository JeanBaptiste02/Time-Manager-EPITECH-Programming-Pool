<template>
  <div class="app-container">
    <login v-if="!isLoggedIn" @loginSuccess="handleLoginSuccess"></login>
    <div v-else>
      <navbar></navbar>
      <router-view></router-view>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import Navbar from "./components/Navbar.vue";
import { useRoute, useRouter } from "vue-router";
import Login from "./components/Login.vue";

const isLoggedIn = ref(localStorage.getItem('jwt_token') !== null);
const route = useRoute();
const router = useRouter();

function handleLoginSuccess() {
  isLoggedIn.value = true;
  router.push({ name: "users" }); // Assurez-vous d'avoir un nom de route correspondant
}

// Ajoutez une navigation de garde pour empêcher l'accès aux pages sans connexion
// Assurez-vous d'ajuster le nom de la route si nécessaire
onMounted(() => {
  if (!isLoggedIn.value && route.name !== "login") {
    router.push({ name: "login" });
  }
});
</script>

<style scoped>
.app-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  min-height: 100vh;
  margin: 20px;
}
</style>
