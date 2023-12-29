<template>
  <div class="login-container">
    <h2>Login</h2>
    <form @submit.prevent="login">
      <h3 class="form-title">Time Manager - Gotham</h3>
      <div class="form-group">
        <label for="username">Username:</label>
        <input type="text" id="username" v-model="username" required />
      </div>
      <div class="form-group">
        <label for="password">Password:</label>
        <input type="password" id="password" v-model="password" required />
      </div>
      <button type="submit">Login</button>
    </form>
  </div>
</template>

<script>
  import axios from 'axios';
  

export default {
  data() {
    return {
      username: "",
      password: "",
    };
  },
  methods: {
    async login() {
        try {
          const response = await axios.post('http://localhost:4000/users/sign_up', {
            username: this.username,
            password: this.password
          });
  
          if (response.status === 200) {
            const data = response.data;
            console.log(data);

            const token = response.data.token;

    
            const decodedToken = parseJwt(token);

            const csrfToken = decodedToken.csrf_token;
            const userId = decodedToken.user_id;
            const  role_user = decodedToken.role;
            
  
    
            localStorage.setItem('jwt_token', token);
            localStorage.setItem('csrf_token', csrfToken);
            localStorage.setItem('user_Id', userId);
            localStorage.setItem('role', role_user);

            this.$router.push('/users');
          } else {
        
            console.error('Échec de l\'authentification');
          }
        } catch (error) {
  
          console.error('Erreur lors de la requête d\'authentification', error);
        }
      }
    }
};

function parseJwt(token) {
  const base64Url = token.split('.')[1];
  const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
  const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
  }).join(''));

  return JSON.parse(jsonPayload);
}

</script>

<style scoped>
.login-container {
  text-align: center;
  background-color: #161616;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 1px 0px 20px 8px rgb(68 68 68 / 10%);
  margin: 10% auto;
  color: #ffffff;
}

.login-container h2 {
  font-size: 24px;
  margin-bottom: 20px;
  color: #007bff;
  font-weight: 900;
  font-size: 30px;
}

.form-title {
  font-size: 18px;
  color: #00db9a;
  margin-bottom: 15px;
  font-weight: 600;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  font-weight: bold;
  display: block;
  margin-bottom: 5px;
  color: #939393;
}

.form-group input[type="text"],
.form-group input[type="password"] {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  outline: none;
  color: #333;
  background-color: rgba(255, 255, 255, 0.8);
}

.form-group input[type="text"]:focus,
.form-group input[type="password"]:focus {
  border-color: #007bff;
}

button[type="submit"] {
  background-color: #007e12;
  color: #fff;
  border: none;
  border-radius: 20px;
  padding: 10px 20px;
  cursor: pointer;
}

button[type="submit"]:hover {
  background-color: #00570d;
  transition: 0.5s;
}

p {
  margin-top: 10px;
}

p a {
  color: #00b4ff;
  font-weight: 600;
}
</style>
