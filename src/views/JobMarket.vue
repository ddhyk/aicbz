<template>
  <div class="job-market">
    <!-- Header -->
    <Header />
    
    <!-- Job Market Banner -->
    <section class="job-banner py-5">
      <div class="container">
        <div class="row">
          <div class="col-12 text-center">
            <h1 class="banner-title mb-3">岗位市场</h1>
            <p class="banner-subtitle mb-4">发现最适合你的职业机会</p>
            
            <!-- Search Bar -->
            <div class="search-container mb-4">
              <div class="row justify-content-center">
                <div class="col-md-8">
                  <div class="input-group">
                    <input 
                      type="text" 
                      class="form-control search-input" 
                      placeholder="搜索职位、公司或关键词"
                      v-model="searchQuery"
                      @keyup.enter="searchJobs"
                    >
                    <button class="btn btn-primary search-btn" @click="searchJobs">
                      <i class="fas fa-search"></i> 搜索
                    </button>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Filters -->
            <div class="filters-container">
              <div class="row justify-content-center">
                <div class="col-md-10">
                  <div class="filter-row d-flex flex-wrap justify-content-center gap-3">
                    <select v-model="filters.industry" class="form-select filter-select">
                      <option value="">所有行业</option>
                      <option value="互联网">互联网</option>
                      <option value="快消">快消</option>
                      <option value="金融">金融</option>
                      <option value="教育">教育</option>
                    </select>
                    
                    <select v-model="filters.workType" class="form-select filter-select">
                      <option value="">工作类型</option>
                      <option value="全职">全职</option>
                      <option value="实习">实习</option>
                      <option value="兼职">兼职</option>
                    </select>
                    
                    <input 
                      type="text" 
                      class="form-control filter-input" 
                      placeholder="工作地点"
                      v-model="filters.location"
                    >
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    
    <!-- Job List Section -->
    <section class="job-list-section py-5">
      <div class="container">
        <div class="row">
          <div class="col-12">
            <!-- Loading State -->
            <div v-if="loading" class="text-center py-5">
              <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">加载中...</span>
              </div>
              <p class="mt-3">正在加载岗位信息...</p>
            </div>
            
            <!-- Error State -->
            <div v-else-if="error" class="alert alert-danger text-center">
              <i class="fas fa-exclamation-triangle"></i>
              {{ error }}
              <button class="btn btn-outline-danger ms-3" @click="fetchJobs">重试</button>
            </div>
            
            <!-- Job Cards -->
            <div v-else>
              <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="section-title">职位列表</h3>
                <span class="job-count">共找到 {{ filteredJobs.length }} 个职位</span>
              </div>
              
              <div class="row">
                <div 
                  v-for="job in paginatedJobs" 
                  :key="job.id" 
                  class="col-lg-6 col-xl-4 mb-4"
                >
                  <div class="job-card h-100">
                    <div class="job-card-header">
                      <div class="d-flex justify-content-between align-items-start">
                        <div class="job-info flex-grow-1">
                          <h5 class="job-title">{{ job.position_title }}</h5>
                          <p class="company-name" v-if="job.company_name">
                            <i class="fas fa-building"></i> {{ job.company_name }}
                          </p>
                        </div>
                        <button 
                          class="btn btn-link bookmark-btn p-0"
                          @click="toggleBookmark(job)"
                          :class="{ 'bookmarked': isBookmarked(job) }"
                        >
                          <i class="fas fa-bookmark"></i>
                        </button>
                      </div>
                    </div>
                    
                    <div class="job-card-body">
                      <div class="job-meta mb-3">
                        <span class="badge bg-primary me-2">{{ job.industry }}</span>
                        <span class="badge bg-secondary me-2">{{ job.work_type }}</span>
                        <span class="location" v-if="job.location">
                          <i class="fas fa-map-marker-alt"></i> {{ job.location }}
                        </span>
                      </div>
                      
                      <div class="salary mb-3" v-if="job.salary_range">
                        <i class="fas fa-money-bill-wave"></i>
                        <strong>{{ job.salary_range }}</strong>
                      </div>
                      
                      <div class="job-description">
                        <p>{{ getJobSummary(job.jd_content) }}</p>
                      </div>
                      
                      <div class="keywords mb-3" v-if="job.extracted_keywords">
                        <div class="keyword-section" v-for="(keywords, category) in job.extracted_keywords" :key="category">
                          <small class="keyword-category">{{ category }}:</small>
                          <div class="keyword-tags">
                            <span 
                              v-for="(keyword, index) in getKeywordArray(keywords)" 
                              :key="index"
                              class="keyword-tag"
                            >
                              {{ keyword }}
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <div class="job-card-footer">
                      <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">
                          发布时间: {{ formatDate(job.created_at) }}
                        </small>
                        <button class="btn btn-primary btn-sm" @click="viewJobDetail(job)">
                          查看详情
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Pagination -->
              <div class="pagination-container mt-5" v-if="totalPages > 1">
                <nav>
                  <ul class="pagination justify-content-center">
                    <li class="page-item" :class="{ disabled: currentPage === 1 }">
                      <button class="page-link" @click="changePage(currentPage - 1)" :disabled="currentPage === 1">
                        上一页
                      </button>
                    </li>
                    <li 
                      v-for="page in visiblePages" 
                      :key="page"
                      class="page-item" 
                      :class="{ active: page === currentPage }"
                    >
                      <button class="page-link" @click="changePage(page)">
                        {{ page }}
                      </button>
                    </li>
                    <li class="page-item" :class="{ disabled: currentPage === totalPages }">
                      <button class="page-link" @click="changePage(currentPage + 1)" :disabled="currentPage === totalPages">
                        下一页
                      </button>
                    </li>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    
    <!-- Job Detail Modal -->
    <div class="job-detail-overlay" v-if="selectedJob" @click="closeJobDetail">
      <div class="job-detail-modal" @click.stop>
        <div class="modal-header">
           <div class="modal-title-section">
             <h5 class="modal-title">{{ selectedJob.position_title }}</h5>
             <button 
               class="btn btn-link bookmark-btn-modal p-0 ms-3"
               @click="toggleBookmark(selectedJob)"
               :class="{ 'bookmarked': isBookmarked(selectedJob) }"
             >
               <i class="fas fa-bookmark"></i>
             </button>
           </div>
           <button type="button" class="btn-close" @click="closeJobDetail">&times;</button>
         </div>
        <div class="modal-body">
          <div class="job-detail-content">
            <div class="company-info mb-4" v-if="selectedJob.company_name">
              <h6><i class="fas fa-building"></i> {{ selectedJob.company_name }}</h6>
            </div>
            
            <div class="job-meta-detail mb-4">
              <div class="row">
                <div class="col-md-6">
                  <p><strong>行业:</strong> {{ selectedJob.industry }}</p>
                  <p><strong>工作类型:</strong> {{ selectedJob.work_type }}</p>
                </div>
                <div class="col-md-6">
                  <p v-if="selectedJob.location"><strong>工作地点:</strong> {{ selectedJob.location }}</p>
                  <p v-if="selectedJob.salary_range"><strong>薪资范围:</strong> {{ selectedJob.salary_range }}</p>
                </div>
              </div>
            </div>
            
            <div class="job-description-detail mb-4">
              <h6>职位描述</h6>
              <div class="job-content" v-html="formatJobContent(selectedJob.jd_content)"></div>
            </div>
            
            <div class="application-info" v-if="selectedJob.email_subject_format">
              <h6>申请方式</h6>
              <p><strong>邮件主题格式:</strong> {{ selectedJob.email_subject_format }}</p>
              <p v-if="selectedJob.resume_format"><strong>简历格式:</strong> {{ selectedJob.resume_format }}</p>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" @click="closeJobDetail">关闭</button>
          <button type="button" class="btn btn-primary" @click="applyJob(selectedJob)">立即申请</button>
        </div>
      </div>
    </div>
    
    <!-- Footer -->
    <Footer />
  </div>
</template>

<script>
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'

export default {
  name: 'JobMarket',
  components: {
    Header,
    Footer
  },
  data() {
    return {
      jobs: [],
      loading: false,
      error: null,
      searchQuery: '',
      filters: {
        industry: '',
        workType: '',
        location: ''
      },
      currentPage: 1,
      itemsPerPage: 9,
      selectedJob: null,
      bookmarkedJobs: new Set(), // 存储收藏的岗位ID
      seenJobs: new Set() // 用于去重的岗位集合
    }
  },
  computed: {
    filteredJobs() {
      let filtered = this.jobs
      
      // Search filter
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase()
        filtered = filtered.filter(job => 
          job.position_title.toLowerCase().includes(query) ||
          (job.company_name && job.company_name.toLowerCase().includes(query)) ||
          job.jd_content.toLowerCase().includes(query)
        )
      }
      
      // Industry filter
      if (this.filters.industry) {
        filtered = filtered.filter(job => job.industry === this.filters.industry)
      }
      
      // Work type filter
      if (this.filters.workType) {
        filtered = filtered.filter(job => job.work_type === this.filters.workType)
      }
      
      // Location filter
      if (this.filters.location) {
        const location = this.filters.location.toLowerCase()
        filtered = filtered.filter(job => 
          job.location && job.location.toLowerCase().includes(location)
        )
      }
      
      return filtered
    },
    paginatedJobs() {
      const start = (this.currentPage - 1) * this.itemsPerPage
      const end = start + this.itemsPerPage
      return this.filteredJobs.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.filteredJobs.length / this.itemsPerPage)
    },
    visiblePages() {
      const pages = []
      const total = this.totalPages
      const current = this.currentPage
      
      if (total <= 7) {
        for (let i = 1; i <= total; i++) {
          pages.push(i)
        }
      } else {
        if (current <= 4) {
          for (let i = 1; i <= 5; i++) {
            pages.push(i)
          }
          pages.push('...', total)
        } else if (current >= total - 3) {
          pages.push(1, '...')
          for (let i = total - 4; i <= total; i++) {
            pages.push(i)
          }
        } else {
          pages.push(1, '...', current - 1, current, current + 1, '...', total)
        }
      }
      
      return pages
    }
  },
  mounted() {
    this.loadBookmarksFromLocalStorage()
    this.fetchJobs()
  },
  methods: {
    async fetchJobs() {
      this.loading = true
      this.error = null
      this.seenJobs.clear() // 重置去重集合
      
      try {
        const response = await fetch('http://211.159.149.77:9999/api/job-descriptions/')
        
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        
        const data = await response.json()
        const rawJobs = data || []
        
        // 过滤垃圾数据和空数据
        this.jobs = this.filterValidJobs(rawJobs)
      } catch (err) {
        console.error('获取岗位数据失败:', err)
        this.error = '获取岗位数据失败，请稍后重试'
      } finally {
        this.loading = false
      }
    },
    filterValidJobs(jobs) {
       return jobs.filter(job => {
         // 过滤掉没有职位标题的岗位
         if (!job.position_title || job.position_title.trim() === '') {
           return false
         }
         
         // 过滤掉职位描述为空或过短的岗位
         if (!job.jd_content || job.jd_content.trim().length < 20) {
           return false
         }
         
         // 过滤掉明显的垃圾数据（如测试数据）
         const title = job.position_title.toLowerCase().trim()
         const content = job.jd_content.toLowerCase().trim()
         
         const spamKeywords = [
           'test', '测试', 'demo', 'sample', '样例', '示例', 
           'xxx', 'yyy', 'zzz', 'aaa', 'bbb', 'ccc',
           '111', '222', '333', 'temp', '临时',
           'placeholder', '占位', 'example', '例子'
         ]
         
         const hasSpam = spamKeywords.some(keyword => 
           title.includes(keyword) || content.includes(keyword)
         )
         
         if (hasSpam) {
           return false
         }
         
         // 过滤掉标题过短或过长的岗位
         if (title.length < 2 || title.length > 100) {
           return false
         }
         
         // 过滤掉只包含特殊字符或数字的标题
         if (!/[\u4e00-\u9fa5a-zA-Z]/.test(title)) {
           return false
         }
         
         // 过滤掉重复的职位（基于标题和公司名称）
         const jobKey = `${job.position_title.trim()}-${(job.company_name || '').trim()}`
         if (this.seenJobs.has(jobKey)) {
           return false
         }
         
         this.seenJobs.add(jobKey)
         
         return true
       })
     },
    searchJobs() {
      this.currentPage = 1
    },
    changePage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page
        window.scrollTo({ top: 0, behavior: 'smooth' })
      }
    },
    toggleBookmark(job) {
      if (this.bookmarkedJobs.has(job.id)) {
        this.bookmarkedJobs.delete(job.id)
      } else {
        this.bookmarkedJobs.add(job.id)
      }
      // 可以在这里添加本地存储或API调用来持久化收藏状态
      this.saveBookmarksToLocalStorage()
    },
    viewJobDetail(job) {
      this.selectedJob = job
      // 使用Vue的响应式数据来控制模态框显示
    },
    closeJobDetail() {
      this.selectedJob = null
    },
    applyJob(job) {
      // TODO: 实现申请逻辑
      console.log('Apply for job:', job.id)
      alert('申请功能正在开发中...')
    },
    isBookmarked(job) {
      return this.bookmarkedJobs.has(job.id)
    },
    saveBookmarksToLocalStorage() {
      localStorage.setItem('bookmarkedJobs', JSON.stringify([...this.bookmarkedJobs]))
    },
    loadBookmarksFromLocalStorage() {
      const saved = localStorage.getItem('bookmarkedJobs')
      if (saved) {
        this.bookmarkedJobs = new Set(JSON.parse(saved))
      }
    },
    getJobSummary(content) {
      if (!content) return '暂无描述'
      const text = content.replace(/\n/g, ' ').replace(/\s+/g, ' ').trim()
      return text.length > 150 ? text.substring(0, 150) + '...' : text
    },
    getKeywordArray(keywords) {
      if (Array.isArray(keywords)) {
        return keywords.slice(0, 3) // 只显示前3个关键词
      }
      if (typeof keywords === 'string') {
        return [keywords]
      }
      return []
    },
    formatDate(dateString) {
      if (!dateString) return '未知'
      const date = new Date(dateString)
      return date.toLocaleDateString('zh-CN')
    },
    formatJobContent(content) {
      if (!content) return '暂无详细描述'
      return content.replace(/\n/g, '<br>').replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    }
  },
  watch: {
    'filters': {
      handler() {
        this.currentPage = 1
      },
      deep: true
    }
  }
}
</script>

<style scoped>
.job-market {
  min-height: 100vh;
  background: #ffffff;
}

.job-banner {
  background: #ffffff;
  color: #1f2937;
  position: relative;
  overflow: hidden;
  min-height: 400px;
  display: flex;
  align-items: center;
  border-bottom: 1px solid #e5e7eb;
}

.job-banner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    radial-gradient(circle at 20% 80%, rgba(0, 0, 0, 0.02) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(0, 0, 0, 0.02) 0%, transparent 50%),
    radial-gradient(circle at 40% 40%, rgba(0, 0, 0, 0.01) 0%, transparent 50%);
}

.job-banner::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 100px;
  background: linear-gradient(to right, transparent 0%, rgba(255,255,255,0.1) 50%, transparent 100%);
  transform: skewY(-2deg);
  transform-origin: bottom left;
}

.banner-title {
  font-size: 3.5rem;
  font-weight: 800;
  margin-bottom: 1rem;
  color: #1f2937;
  text-shadow: none;
}



.banner-subtitle {
  font-size: 1.3rem;
  color: #6b7280;
  font-weight: 400;
  text-shadow: none;
}

.search-container {
  max-width: 600px;
  margin: 0 auto;
}

.search-input {
  border: 1px solid #d1d5db;
  border-radius: 30px 0 0 30px;
  padding: 1rem 1.5rem;
  font-size: 1.1rem;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
  background: #ffffff;
  color: #374151;
  transition: all 0.3s ease;
}

.search-input::placeholder {
  color: #9ca3af;
}

.search-input:focus {
  border-color: #3b82f6;
  background: #ffffff;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1), 0 0 0 3px rgba(59, 130, 246, 0.1);
  transform: translateY(-1px);
}

.search-input::placeholder {
  color: #6b7280;
  font-weight: 400;
}

.search-btn {
  border-radius: 0 30px 30px 0;
  padding: 1rem 2.5rem;
  font-weight: 600;
  border: 1px solid #3b82f6;
  background: #3b82f6;
  box-shadow: 0 4px 16px rgba(59, 130, 246, 0.2);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.search-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  transition: left 0.5s;
}

.search-btn:hover::before {
  left: 100%;
}

.search-btn:hover {
  background: #2563eb;
  transform: translateY(-1px);
  box-shadow: 0 8px 24px rgba(59, 130, 246, 0.3);
}

.filters-container {
  margin-top: 2rem;
}

.filter-row {
  gap: 1rem;
}

.filter-select,
.filter-input {
  max-width: 200px;
  border-radius: 25px;
  padding: 12px 18px;
  border: 1px solid #d1d5db;
  background: #ffffff;
  color: #374151;
  font-size: 0.95rem;
  font-weight: 500;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  min-width: 160px;
}

.filter-select:focus,
.filter-input:focus {
  border-color: #3b82f6;
  background: #ffffff;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1), 0 0 0 3px rgba(59, 130, 246, 0.1);
  transform: translateY(-1px);
}

.filter-select:hover,
.filter-input:hover {
  border-color: #9ca3af;
  background: #ffffff;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.filter-select option {
  color: #333;
}

.filter-input::placeholder {
  color: #999;
}

.job-list-section {
  background: #ffffff;
}

.section-title {
  color: #333;
  font-weight: 600;
}

.job-count {
  color: #666;
  font-size: 0.9rem;
}

.job-card {
  background: white;
  border-radius: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
  border: 1px solid #e9ecef;
  overflow: hidden;
}

.job-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.15);
  border-color: #667eea;
}

.job-card-header {
  padding: 1.5rem 1.5rem 0;
}

.job-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 0.5rem;
  line-height: 1.4;
}

.company-name {
  color: #666;
  font-size: 0.9rem;
  margin-bottom: 0;
}

.company-name i {
  color: #999;
  margin-right: 5px;
}

.bookmark-btn {
  color: #ddd;
  font-size: 1.2rem;
  transition: all 0.3s ease;
}

.bookmark-btn:hover {
  color: #ffc107;
  transform: scale(1.1);
}

.bookmark-btn.bookmarked {
  color: #ffc107;
  text-shadow: 0 0 8px rgba(255, 193, 7, 0.5);
}

.job-card-body {
  padding: 0 1.5rem 1rem;
}

.job-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  align-items: center;
}

.badge {
  font-size: 0.75rem;
  padding: 0.4rem 0.8rem;
  border-radius: 20px;
  font-weight: 500;
}

.badge.bg-primary {
  background: linear-gradient(45deg, #667eea, #764ba2) !important;
  border: none;
}

.badge.bg-secondary {
  background: linear-gradient(45deg, #6c757d, #495057) !important;
  border: none;
}

.location {
  color: #666;
  font-size: 0.85rem;
}

.location i {
  color: #999;
  margin-right: 3px;
}

.salary {
  color: #28a745;
  font-weight: 600;
}

.salary i {
  margin-right: 5px;
}

.job-description {
  color: #666;
  font-size: 0.9rem;
  line-height: 1.5;
}

.keywords {
  max-height: 100px;
  overflow: hidden;
}

.keyword-section {
  margin-bottom: 0.5rem;
}

.keyword-category {
  color: #999;
  font-weight: 600;
  display: block;
  margin-bottom: 0.25rem;
}

.keyword-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.25rem;
}

.keyword-tag {
  background: linear-gradient(45deg, #f8f9fa, #e9ecef);
  color: #495057;
  padding: 0.2rem 0.5rem;
  border-radius: 10px;
  font-size: 0.75rem;
  border: 1px solid #dee2e6;
  transition: all 0.3s ease;
}

.keyword-tag:hover {
  background: linear-gradient(45deg, #667eea, #764ba2);
  color: white;
  transform: translateY(-1px);
  box-shadow: 0 2px 4px rgba(102, 126, 234, 0.2);
}

.job-card-footer {
  padding: 1rem 1.5rem;
  background: #fafbfc;
  border-top: 1px solid #f1f3f4;
}

.pagination-container {
  margin-top: 3rem;
}

.page-link {
  border-radius: 8px;
  margin: 0 2px;
  border: 1px solid #dee2e6;
  color: #667eea;
  transition: all 0.3s ease;
}

.page-link:hover {
  background: linear-gradient(45deg, #667eea, #764ba2);
  border-color: #667eea;
  color: white;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

.page-item.active .page-link {
  background: linear-gradient(45deg, #667eea, #764ba2);
  border-color: #667eea;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

.modal-content {
  border-radius: 15px;
  border: none;
}

.modal-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 15px 15px 0 0;
}

.btn-close {
  filter: invert(1);
}

.job-detail-content {
  line-height: 1.6;
}

.job-content {
  background: #fafbfc;
  padding: 1rem;
  border-radius: 8px;
  white-space: pre-line;
  border: 1px solid #f1f3f4;
}

/* 自定义模态框样式 */
.job-detail-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1050;
}

.job-detail-modal {
  background: white;
  border-radius: 8px;
  max-width: 800px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.job-detail-modal .modal-header {
   padding: 20px;
   border-bottom: 1px solid #dee2e6;
   display: flex;
   justify-content: space-between;
   align-items: center;
 }
 
 .modal-title-section {
   display: flex;
   align-items: center;
 }
 
 .bookmark-btn-modal {
   color: #6c757d;
   text-decoration: none;
   font-size: 1.2rem;
   transition: color 0.3s ease;
 }
 
 .bookmark-btn-modal:hover {
   color: #ffc107;
 }
 
 .bookmark-btn-modal.bookmarked {
   color: #ffc107;
 }

.job-detail-modal .modal-title {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
  color: #2c3e50;
}

.job-detail-modal .btn-close {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #6c757d;
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.job-detail-modal .btn-close:hover {
  color: #000;
}

.job-detail-modal .modal-body {
  padding: 20px;
}

.job-detail-modal .modal-footer {
  padding: 20px;
  border-top: 1px solid #dee2e6;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

@media (max-width: 768px) {
  .banner-title {
    font-size: 2rem;
  }
  
  .filter-row {
    flex-direction: column;
    align-items: center;
  }
  
  .filter-select,
  .filter-input {
    max-width: 100%;
    width: 250px;
  }
  
  .job-card {
    margin-bottom: 1rem;
  }
  
  .job-detail-modal {
    width: 95%;
    margin: 10px;
  }
  
  .job-detail-modal .modal-header,
  .job-detail-modal .modal-body,
  .job-detail-modal .modal-footer {
    padding: 15px;
  }
}
</style>