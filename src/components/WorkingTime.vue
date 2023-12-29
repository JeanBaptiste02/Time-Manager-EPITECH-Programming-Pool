<template>
  <div>
    <h1>Working Time</h1>
    <table v-if="workingTimes.length > 0" class="user-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Heure de début</th>
          <th>Heure de fin</th>
          <th>ID de l'utilisateur</th>
          <th>Statut</th>

        </tr>
      </thead>
      <tbody>
        <tr v-for="(item, index) in workingTimes" :key="index">
          <td>{{ item.id }}</td>
          <td>{{ item.time }}</td>
          <td>{{ item.time }}</td>
          <td>{{ item.user_id }}</td>
          <td>{{ item.status }}</td>
          <td v-if="userRole === 'true'">              <button
                @click="deleteWorkingtime(item.id)"
                style="background-color: rgb(165, 0, 0)"
              >
                Delete
              </button></td>

        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      userId: null,
      workingTimes: [],
    };
  },
  computed:{
    userRole() {
    return localStorage.getItem('role') || '';
    },
  },
  methods: {
    async fetchWorkingTime() {
      try {
        const token = localStorage.getItem('jwt_token');
        this.userId = localStorage.getItem('user_id');

        const response = await axios.get(`http://localhost:4000/api/auth/clocks/${this.userId}`, {
          headers: {
            'Authorization': `Bearer ${token}`,
          },
        });

        this.workingTimes = response.data.data;
        console.log(this.workingTimes);
      } catch (error) {
        console.error("Erreur lors du chargement de l'historique de travail :", error);
      }
    },
    deleteWorkingtime(userId) {
      const token = localStorage.getItem('jwt_token');
      axios
        .delete(`http://localhost:4000/api/auth/clocks/${userId}`,{
          headers: {
            'Authorization': `Bearer ${token}`,
          },})
        .then(() => {
          this.users = this.users.filter((user) => user.id !== userId);
        })
        .catch((error) => {
          console.error("Error deleting user:", error);
        });
    },
  },
  mounted() {
    this.fetchWorkingTime();
  },
};
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


  .user-table button,
  .user-table input {
    padding: 5px 10px;
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
