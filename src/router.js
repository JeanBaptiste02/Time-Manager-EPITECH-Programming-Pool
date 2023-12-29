import { createRouter, createWebHistory } from "vue-router";
import User from "./components/User.vue";
import WorkingTimes from "./components/WorkingTimes.vue";
import WorkingTime from "./components/WorkingTime.vue";
import ClockManager from "./components/ClockManager.vue";
import ChartManager from "./components/ChartManager.vue";

const routes = [
  { path: "/users", component: User },
  { path: "/workingTimes", component: WorkingTimes },
  { path: "/workingTime", component: WorkingTime },
  { path: "/workingTime/:userId/:workingTimeId", component: WorkingTime },
  { path: "/clock/:username", component: ClockManager },
  { path: "/chartManager", component: ChartManager },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
