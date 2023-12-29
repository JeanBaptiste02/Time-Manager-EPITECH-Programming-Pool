<template>
  <div>
    <h1>Chart Manager</h1>
    <Bar id="my-chart-id" :options="chartOptions" :data="chartData" />
  </div>
</template>

<script>
import { Bar } from "vue-chartjs";
import { Chart, LinearScale, CategoryScale, BarElement } from "chart.js";
Chart.register(LinearScale, CategoryScale, BarElement);

export default {
  name: "BarChart",
  components: { Bar },
  data() {
    return {
      chartData: {
        labels: [],
        datasets: [],
      },
      chartOptions: {
        responsive: true,
        scales: {
          x: {
            type: "linear",
            position: "bottom",
            ticks: {
              stepSize: 1,
            },
          },
          y: {
            type: "category",
          },
        },
      },
    };
  },
  async mounted() {
    try {
      const token = localStorage.getItem("jwt_token");

      if (!token) {
        console.error("JWT token not found in localStorage");
        return;
      }
      console.log("Token", token);

      const response = await fetch(
        "http://localhost:4000/api/auth/workingtimes",
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (response.ok) {
        const workingTimesResponse = await response.json();
        const workingTimes = workingTimesResponse.data;

        console.log("Working Times Response:", workingTimesResponse);
        console.log("Working Times Data:", workingTimes);

        if (Array.isArray(workingTimes)) {
          const userIds = [...new Set(workingTimes.map((wt) => wt.user_id2))];
          this.chartData.labels = userIds.map((userId) => `User ${userId}`);
          const dataByUser = userIds.map((userId) => {
            return {
              x: 0,
              y: `User ${userId}`,
            };
          });

          workingTimes.forEach((wt) => {
            const userIdIndex = userIds.indexOf(wt.user_id2);
            if (userIdIndex !== -1) {
              const startHour = new Date(wt.start).getHours();
              const endHour = new Date(wt.end).getHours();
              dataByUser[userIdIndex].x += endHour - startHour + 1;
            }
          });
          this.chartData.datasets.push({
            label: "Total Hours",
            backgroundColor: "rgba(75, 192, 192, 0.2)",
            borderColor: "rgba(75, 192, 192, 1)",
            borderWidth: 1,
            data: dataByUser,
          });
        } else {
          console.error("workingTimes is not an array");
        }
      } else {
        console.error("API request failed with status: " + response.status);
      }
    } catch (error) {
      console.error("Error during API request:", error);
    }
  },
};
</script>

<style scoped>
h1 {
  font-size: 24px;
  margin-bottom: 20px;
  color: #0af;
  font-weight: 900;
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
</style>
