<template>
  <div>
    <h1>User Informations</h1>
    <div v-if="userRole === 'true'">
          <input
      v-model="search"
      placeholder="Search by username or ID"
      style="width: 80%"
    />
    <div class="user-information">
      <table
        v-show="search.length > 0 && filteredUsers.length > 0"
        class="user-table"
      >
        <thead>
          <tr>
            <th>ID</th>
            <th>User Name</th>
            <th>Email</th>
            <th>Update</th>
            <th>Delete</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in filteredUsers" :key="user.id">
            <td>{{ user.id }}</td>
            <td><input type="text" v-model="user.username" required /></td>
            <td><input type="text" v-model="user.email" required /></td>
            <td>
              <button
                @click="updateUser(user)"
                style="background-color: rgb(114, 64, 214)"
              >
                Update
              </button>
            </td>
            <td>
              <button
                @click="deleteUser(user.id)"
                style="background-color: rgb(165, 0, 0)"
              >
                Delete
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      <button @click="showAddNewForm" style="margin-top: 10px">
        + Add User
      </button>
    </div>
    <form v-if="addUser" @submit.prevent="saveUser">
      <div class="form-group">
        <label for="newUsername">User Name</label>
        <input id="newUsername" v-model="newUser.username" required />
      </div>
      <div class="form-group">
        <label for="newEmail">Email:</label>
        <input id="newEmail" v-model="newUser.email" type="email" required />
      </div>
      <div class="form-group">
        <label for="Password">Password:</label>
        <input id="Password" v-model="newUser.password" type="password" required />
      </div>
      <button
        type="submit"
        style="margin-top: 10px; background-color: rgb(0, 122, 31)"
      >
        Save
      </button>
      <button
        @click="hideAddNewForm"
        style="
          margin-left: 5px;
          margin-top: 10px;
          background-color: rgb(180, 0, 0);
        "
      >
        Cancel
      </button>
    </form>
  </div>
  <div v-else>
    <div class="user-information">
    <table class="user-table">
        <tr>
          <th>id</th>
          <th>Nom</th>
          <th>Email</th>

        </tr>
        <tr>
          <td>{{ users.id }}</td>
          <td><input type="text" v-model="users.username" required /></td>
          <td><input type="text" v-model="users.email" required /></td>

          <td>
              <button
                @click="updateUser(users)"
                style="background-color: rgb(114, 64, 214)"
              >
                Update
              </button>
            </td>

        </tr>
      </table>
  </div>
</div>
</div>

</template>

<script>
import axios from "axios";
console.log(localStorage.getItem('role'));
const token = localStorage.getItem('jwt_token');
import { ref } from "vue";



export default {

  data() {
    return {
      users: [],
      addUser: false,
      newUser: {
        username: "",
        email: "",
        password: "",
      },
      search: "",
      selectedUser: null,
    };
  },
  computed: {
    filteredUsers() {
      return this.users.filter((user) => {
        const byUsername = user.username
          .toLowerCase()
          .includes(this.search.toLowerCase());
        const byId =
          this.search &&
          !isNaN(this.search) &&
          user.id.toString() === this.search;

        return byUsername || byId;
      });
    },
    userRole() {
    return localStorage.getItem('role') || '';
  },
  },
  methods: {
    
    updateUser(user) {
  if (user && user.username && user.email) {
    axios
      .put(`http://localhost:4000/api/auth/users/${user.id}`, {
          username: user.username,
          email: user.email,
        
      }, {
        headers: {
          'Authorization': `Bearer ${token}`,
        },
      })
      .then((response) => {
        console.log(response);

        if (response && response.data && response.data.data) {
          const responseData = response.data.data;
          const updatedUser = responseData.user;

          if (updatedUser) {
            const updatedUserIndex = this.users.findIndex((u) => u.id === user.id);

            if (updatedUserIndex !== -1) {
              this.users[updatedUserIndex] = updatedUser;
            } else {
              console.error("User not found in the list.");
            }
          } else {
            console.error("User is undefined in the response.");
          }
        } else {
          console.error("Invalid response structure.");
        }
      })
      .catch((error) => {
        console.error("Error updating user:", error);
      });
  } else {
    console.error("Invalid user data.");
  }
}
,
    deleteUser(userId) {
      axios
           .delete(`http://localhost:4000/api/auth/users/${userId}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    })
        .then(() => {
          this.users = this.users.filter((user) => user.id !== userId);
        })
        .catch((error) => {
          console.error("Error deleting user:", error);
        });
    },
    getUsers() {
      axios
      .get("http://localhost:4000/api/auth/users", {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    })
        .then((response) => {
          this.users = response.data.data;
        },)
        .catch((error) => {
          console.error("Error fetching users:", error);
        });
    },
    getUserById(userId) {
      return this.users.find((user) => user.id === userId);
    },
    showUserInfo(user) {
      this.selectedUser = user;
    },
    showAddNewForm() {
      this.addUser = true;
    },
    hideAddNewForm() {
      this.addUser = false;
    },
    saveUser() {
  axios
    .post(
      "http://localhost:4000/api/auth/users/",
      {
        user: {
          username: this.newUser.username,
          email: this.newUser.email,
          password: this.newUser.password,
        },
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`,
        },
      }
    )
    .then((response) => {
      if (response.data.user) {
        this.users.push(response.data.user);

        this.newUser = {
          username: "",
          email: "",
          password: "",
        };
        this.addUser = false;
      } else {
        console.error("Response is not defined.");
      }
    })
    .catch((error) => {
      console.error("Error saving user:", error);
    });
},

getUser(userId) {
      axios
      .get(`http://localhost:4000/api/auth/users/${userId}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    })
        .then((response) => {
          this.users = response.data.data;
        },)
        .catch((error) => {
          console.error("Error fetching user:", error);
        });
    }

  },
  mounted() {
    
    if (localStorage.getItem('role') === 'true') {
    this.getUsers();
    }

    const userId = localStorage.getItem('user_Id');


    if (userId) {

      this.getUser(userId);
    } else {
      console.error("ID de l'utilisateur non trouvé dans le localStorage.");
    }
  },
};
function getrole(){
  
  return localStorage.getItem('role');
  
}
</script>

<style scoped>
.user-information {
  margin-top: 20px;
}

h1 {
  font-size: 24px;
  margin-bottom: 20px;
  color: #0af;
  font-weight: 900;
}

button {
  background-color: #007bff;
  color: #fff;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
}

.button-container {
  margin: 20px 0;
}

.user-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 90px;
}

.user-table th,
.user-table td {
  padding: 10px;
  text-align: left;
  border: 1px solid #e0e0e0;
  color: white;
}

.user-table th {
  background-color: #007bff;
  color: #fff;
}

.label-container {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

label {
  color: #ffffff;
  font-weight: bold;
}

input {
  flex: 1;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 5px;
  margin-left: 10px;
  background-color: #313131;
  color: white;
}

.form-group {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.form-group label {
  width: 90px;
  margin-right: 10px;
  color: #ffffff;
}

.form-group input {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 10px;
  margin-top: 20px;
}

@media (max-width: 767px) {
  .user-table {
    width: 100%;
    overflow-x: auto;
  }

  .user-table th,
  .user-table td {
    padding: 5px;
    max-width: 100px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  input {
    width: 70px;
    font-size: 12px;
  }

  /* Ajustez la taille des boutons et des champs de texte dans le tableau */
  .user-table button,
  .user-table input {
    padding: 5px 10px; /* Ajustez la taille des boutons et des champs de texte */
  }

  .label-container {
    flex-direction: column;
  }

  .label-container label {
    margin-bottom: 5px;
  }

  .form-group {
    flex-direction: column;
  }

  .form-group label {
    margin-right: 0;
    margin-bottom: 5px;
  }

  .form-group input {
    margin-top: 0;
  }
}
</style>
