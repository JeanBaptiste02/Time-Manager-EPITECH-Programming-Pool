<template>
  <div>
    <h1>Clock Manager</h1>
    <input v-model="search" placeholder="Search by username or ID" />
    <div class="user-information">
      <table
        v-show="search.length > 0 && filteredUsers.length > 0"
        class="user-table"
      >
        <thead>
          <tr>
            <th>ID</th>
            <th>User Name</th>
            <th>Start Time</th>
            <th>End Time</th>
            <th>Clock In</th>
            <th>Clock Out</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in filteredUsers" :key="user.id">
            <td>{{ user.id }}</td>
            <td>{{ user.username }}</td>
            <td>{{ user.startTime || "N/A" }}</td>
            <td>{{ user.endTime || "N/A" }}</td>
            <td>
              <button @click="clockIn(user)" :disabled="user.clockIn">
                Clock In
              </button>
            </td>
            <td>
              <button @click="clockOut(user)" :disabled="user.clockOut">
                Clock Out
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from "axios";
const token = localStorage.getItem('jwt_token');

export default {
  data() {
    return {
      users: [],
      search: "",
      startTime: null,
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
  },
  methods: {
    toggleClock(user) {
      if (user.clockIn) {
        this.clockOut(user);
      } else {
        this.clockIn(user);
      }
    },

    async clockIn(user) {
      const startTime = new Date();
      user.startTime = startTime.toISOString();
      user.clockIn = true;

      const url = `http://localhost:4000/api/auth/clocks/${user.id}`;

      try {
        const response = await axios.post(url, { user_id: user.id },{ headers: {
          'Authorization': `Bearer ${token}`,
        },});

        console.log("Enregistrement réussi dans clocks:", response.data);
      } catch (error) {
        console.error(
          "Erreur lors de l'enregistrement dans la table 'clock':",
          error
        );
      }
    },

    async clockOut(user) {

  try {
    const endTime = new Date();
    const startTime = new Date(user.startTime);

    user.endTime = endTime.toISOString();
    user.clockIn = false;

    const url1 = `http://localhost:4000/api/auth/workingtimes/${user.id}`;

    const requestData = {
      
      workingtime: {
        start: startTime.toISOString(),
        end: endTime.toISOString(),
        user_id2: user.id,
      },
    };


    const response = await axios.put(url1, requestData, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });


    console.log('Réponse de la requête PUT :', response.data);

   
  } catch (error) {
    console.error('Erreur lors de la mise à jour du temps de travail :', error);

  }
},
  },
  mounted() {

    axios
    .get("http://localhost:4000/api/auth/users", {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    })
      .then((response) => {
        this.users = response.data.data;
      })
      .catch((error) => {
        console.error("Error fetching users:", error);
      });
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
  background-color: #530088;
  color: #fff;
  border: none;
  padding: 10px 20px;
  border-radius: 20px;
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
  widows: 40px;
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
</style>
