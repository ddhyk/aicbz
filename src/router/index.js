import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import JobMarket from '../views/JobMarket.vue'
import ResumeOptimizer from '../views/ResumeOptimizer.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/jobs',
    name: 'JobMarket',
    component: JobMarket
  },
  {
    path: '/resume-optimizer',
    name: 'ResumeOptimizer',
    component: ResumeOptimizer
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router