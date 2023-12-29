<template>
  <nav class="navbar">
    <div class="navbar-left">
      <span class="navbar-title">Time Manager</span>
    </div>
    <div class="navbar-right">
      <input type="checkbox" id="menu-toggle" class="menu-toggle" />
      <label for="menu-toggle" class="menu-icon">&#9776;</label>
      <div class="nav-links">
        <router-link to="/users" class="nav-link">User</router-link>
        <router-link to="/workingTimes" class="nav-link"
          >Working Times</router-link
        >
        <router-link to="/workingTime" class="nav-link"
          >Working Time</router-link
        >
        <router-link to="/clock/:username" class="nav-link"
          >Clock Manager</router-link
        >
        <router-link to="/chartManager" class="nav-link"
          >Chart Manager</router-link
        >
        <br />
        <button @click="SignOut" class="logout-button">Sign out</button>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref } from "vue";

const showMenu = ref(false);
import axios from 'axios';
import { useRouter } from "vue-router";

const isLoggedIn = ref(localStorage.getItem('jwt_token') !== null);
const router = useRouter();

async function SignOut() {
  try {

    await axios.post('http://localhost:4000/users/sign_out');


    localStorage.removeItem('csrf_token');
    localStorage.removeItem('user_Id');
    localStorage.removeItem('jwt_token');


    router.push('/login'); 
  } catch (error) {

    console.error('Erreur lors de la déconnexion', error);
  }
}

const toggleMenu = () => {
  showMenu.value = !showMenu.value;
};
</script>

<style scoped>
.navbar {
  background-color: #181818;
  padding: 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  border-radius: 20px;
  margin-bottom: 30px;
}

.navbar-left {
  display: flex;
  align-items: center;
}

.navbar-title {
  color: #0193f7;
  font-size: 24px;
  margin-right: 20px;
  font-weight: 900;
}

.navbar-right {
  display: flex;
  align-items: center;
}

.menu-toggle {
  display: none;
}

.menu-icon {
  font-size: 24px;
  color: #fff;
  cursor: pointer;
  display: none;
}

.nav-links {
  display: flex;
}

.nav-link {
  color: #fff;
  text-decoration: none;
  margin: 0 15px;
  font-weight: bold;
  font-size: 18px;
  padding: 8px;
  transition: color 0.3s ease;
}

.nav-link:hover {
  color: #00aeff;
}

.logout-button {
  background-color: #f00;
  color: #fff;
  border: none;
  border-radius: 5px;
  padding: 8px 15px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.3s ease;
}

.logout-button:hover {
  background-color: #c00;
}

@media (max-width: 768px) {
  .menu-icon {
    display: block;
  }

  .nav-links {
    display: none;
    flex-direction: column;
    align-items: flex-start;
  }

  .menu-toggle:checked + .menu-icon + .nav-links {
    display: flex;
  }
}
</style>
