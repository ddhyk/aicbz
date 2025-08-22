<template>
  <section class="client-logo-con">
    <div class="container">
      <div class="row">
        <div class="col-12">
          <div class="client-logo-content text-center" data-aos="fade-up">
            <h6>Trusted by professionals from leading companies</h6>
            <div class="client-logos">
              <figure class="mb-0">
                <img src="../assets/images/client-logo1.png" alt="client-logo1" class="img-fluid">
              </figure>
              <figure class="mb-0">
                <img src="../assets/images/client-logo2.png" alt="client-logo2" class="img-fluid">
              </figure>
              <figure class="mb-0">
                <img src="../assets/images/client-logo3.png" alt="client-logo3" class="img-fluid">
              </figure>
              <figure class="mb-0">
                <img src="../assets/images/client-logo4.png" alt="client-logo4" class="img-fluid">
              </figure>
              <figure class="mb-0">
                <img src="../assets/images/client-logo5.png" alt="client-logo5" class="img-fluid">
              </figure>
              <figure class="mb-0">
                <img src="../assets/images/client-logo6.png" alt="client-logo6" class="img-fluid">
              </figure>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'ClientLogos',
  mounted() {
    // Initialize AOS animations if available
    if (typeof AOS !== 'undefined') {
      AOS.init();
    }
  }
}
</script>

<style scoped>
/* Client logos specific styles are in the main CSS file */
</style>