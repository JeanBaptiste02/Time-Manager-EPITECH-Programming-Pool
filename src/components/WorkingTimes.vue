<template>
  <div>
    <h1>Working Times</h1>
    <div v-if="userRole === 'true'">

    <input v-model="search" placeholder="Search by username or ID" />


    <div v-if="selectedUser" class="user-information"> 
      <h2>User Information</h2>
      <p><strong>ID:</strong> {{ selectedUser.id }}</p>
      <p><strong>User Name:</strong> {{ selectedUser.username }}</p>
      <p><strong>Start Time:</strong> {{ selectedUser.start }}</p>
      <p><strong>End Time:</strong> {{ selectedUser.end }}</p>
    </div>

    <div class="workingtimes-informations">
      <table
        v-show="search.length > 0 && filteredUsers.length > 0"
        class="workingtimes-table"
      >
        <thead>
          <tr>
            <th>ID</th>
            <th>User Name</th>
            <th>Start Time</th>
            <th>End Time</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="workingtime in filteredUsers" :key="workingtime.id">
            <td>{{ workingtime.id }}</td>
            <td>{{ getUsername(workingtime.id) }}</td>
            <td>{{ workingtime.start }}</td>
            <td>{{ workingtime.end }}</td>
            <td>
              <button
                @click="showUserInfo(workingtime)"
                style="
                  background-color: #b70062;
                  border-radius: 20px;
                  padding: 5px;
                "
              >
                Show User
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    </div>
    <div v-else>
<p     style="color: red;width: 60%;   margin-left: auto;
    margin-right: auto; font-weight: bold;">We regret to inform you that your current account do not grant you the necessary access rights to view the contents of this page</p>
    </div>
  </div>
  
</template>

<script>
import axios from "axios";
const token = localStorage.getItem("jwt_token");

export default {
  data() {
    return {
      users: [],
      search: "",
      selectedUser: null, 
      userId: null, 
    };
  },
  computed: {
    filteredUsers() {
      return this.users.filter((workingtime) => {
        const byUsername = workingtime.start
          .toLowerCase()
          .includes(this.search.toLowerCase());
        const byId =
          this.search &&
          !isNaN(this.search) &&
          workingtime.id.toString() === this.search;

        return byUsername || byId;
      });
    },
    userRole() {
    return localStorage.getItem('role') || '';
    },
  },
  methods: {
    async getUsers() {
    
      try {
        if (this.userId) {
          const url = `http://localhost:4000/api/auth/workingtimes/${this.userId}`;

   
          const response = await axios.get(url, {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });

          this.selectedUser = response.data.data;
        } else {

          const url = "http://localhost:4000/api/auth/workingtimes";

          
          const response = await axios.get(url, {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });

    
          this.users = response.data.data;
        }
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des utilisateurs :",
          error
        );
    
      }
    },

    getUsername(userId) {
      const workingtime = this.users.find(
        (workingtime) => workingtime.id === userId
      );
      return workingtime ? workingtime.username : "Utilisateur non trouvé";
    },

    showUserInfo(workingtime) {
      this.selectedUser = workingtime;
      this.userId = workingtime.id; 
    },
  },
  mounted() {
    this.getUsers();
  },
};
</script>

<style scoped>
.workingtimes-informations {
  margin-top: 20px;
}

h1 {
  font-size: 24px;
  margin-bottom: 20px;
  color: #0af;
  font-weight: 900;
}

.workingtimes-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 90px;
}

.workingtimes-table th,
.workingtimes-table td {
  padding: 10px;
  text-align: left;
  border: 1px solid #e0e0e0;
  color: white;
}

.workingtimes-table th {
  background-color: #007bff;
  color: #fff;
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
</style>d