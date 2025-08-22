<template>
  <div class="loader-mask" v-if="isLoading">
    <div class="loader">
      <div></div>
      <div></div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Preloader',
  data() {
    return {
      isLoading: true
    }
  },
  mounted() {
    // Hide preloader after page loads
    window.addEventListener('load', () => {
      setTimeout(() => {
        this.isLoading = false;
      }, 500); // Small delay for smooth transition
    });
    
    // Fallback: hide preloader after 3 seconds
    setTimeout(() => {
      this.isLoading = false;
    }, 3000);
  }
}
</script>

<style scoped>
/* Preloader styles are in the main CSS file */
</style>