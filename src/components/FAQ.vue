<template>
  <section class="faq-con padding-top padding-bottom" id="faq-con">
    <div class="container">
      <div class="row">
        <div class="col-12">
          <div class="faq_content">
            <div class="heading-title-con text-center" data-aos="fade-up">
              <div class="special-text">FAQ</div>
              <h2>Frequently Asked <span class="color-blue">Questions</span></h2>
              <p class="text-size-18">Find answers to common questions about our AI-powered resume optimization service.</p>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-12">
          <div class="faq-accordion" data-aos="fade-up">
            <div class="accordion" id="faqAccordion">
              <div class="accordion-item" v-for="(faq, index) in faqs" :key="index">
                <h2 class="accordion-header" :id="'heading' + index">
                  <button 
                    class="accordion-button" 
                    :class="{ collapsed: !faq.isOpen }"
                    type="button" 
                    @click="toggleFAQ(index)"
                    :aria-expanded="faq.isOpen"
                    :aria-controls="'collapse' + index"
                  >
                    {{ faq.question }}
                  </button>
                </h2>
                <div 
                  :id="'collapse' + index" 
                  class="accordion-collapse collapse" 
                  :class="{ show: faq.isOpen }"
                  :aria-labelledby="'heading' + index"
                >
                  <div class="accordion-body">
                    <p class="text-size-16">{{ faq.answer }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'FAQ',
  data() {
    return {
      faqs: [
        {
          question: 'How does the AI resume optimization work?',
          answer: 'Our AI analyzes your resume content, structure, and formatting against industry standards and ATS requirements. It then provides personalized recommendations to improve keyword optimization, content clarity, and overall impact.',
          isOpen: true
        },
        {
          question: 'Is my resume data secure and private?',
          answer: 'Absolutely. We use enterprise-grade security measures to protect your data. Your resume information is encrypted and never shared with third parties. You can delete your data at any time.',
          isOpen: false
        },
        {
          question: 'What file formats do you support?',
          answer: 'We support all major resume formats including PDF, Word (.doc, .docx), and plain text files. Our system can process and optimize resumes in any of these formats.',
          isOpen: false
        },
        {
          question: 'How long does the optimization process take?',
          answer: 'The AI analysis and optimization process typically takes 2-5 minutes depending on the length and complexity of your resume. You\'ll receive instant feedback and suggestions.',
          isOpen: false
        },
        {
          question: 'Can I customize the optimization suggestions?',
          answer: 'Yes! While our AI provides intelligent recommendations, you have full control over which suggestions to accept or modify. You can also specify your target industry and role for more tailored optimization.',
          isOpen: false
        },
        {
          question: 'Do you offer refunds if I\'m not satisfied?',
          answer: 'We offer a 30-day money-back guarantee. If you\'re not completely satisfied with our service, contact our support team for a full refund within 30 days of purchase.',
          isOpen: false
        }
      ]
    }
  },
  methods: {
    toggleFAQ(index) {
      this.faqs[index].isOpen = !this.faqs[index].isOpen;
      // Close other FAQs (optional - for accordion behavior)
      // this.faqs.forEach((faq, i) => {
      //   if (i !== index) {
      //     faq.isOpen = false;
      //   }
      // });
    }
  },
  mounted() {
    // Initialize AOS animations if available
    if (typeof AOS !== 'undefined') {
      AOS.init();
    }
  }
}
</script>

<style scoped>
/* FAQ specific styles are in the main CSS file */
</style>