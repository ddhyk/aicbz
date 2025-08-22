<template>
  <a 
    id="button" 
    href="#" 
    :class="{ show: isVisible }"
    @click.prevent="scrollToTop"
    title="Back to Top"
  >
  </a>
</template>

<script>
export default {
  name: 'BackToTop',
  data() {
    return {
      isVisible: false
    }
  },
  methods: {
    scrollToTop() {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    },
    handleScroll() {
      // Show button when user scrolls down 300px from top
      this.isVisible = window.pageYOffset > 300;
    }
  },
  mounted() {
    // Add scroll event listener
    window.addEventListener('scroll', this.handleScroll);
  },
  beforeUnmount() {
    // Remove scroll event listener
    window.removeEventListener('scroll', this.handleScroll);
  }
}
</script>

<style scoped>
/* Back to top button styles are in the main CSS file */
</style>