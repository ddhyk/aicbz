<template>
  <div class="resume-optimizer">
    <!-- Header -->
    <Header />
    
    <!-- Main Content -->
    <div class="main-container">
      <div class="content-wrapper">
        <!-- Left Panel - Configuration -->
        <div class="left-panel">
          <div class="config-card">
            <div class="card-header">
              <h2 class="card-title">
                <i class="fas fa-magic"></i>
                AI简历优化
              </h2>
              <p class="card-subtitle">智能分析，精准优化</p>
            </div>
            
            <div class="card-body">
              <!-- 简历上传区域 -->
              <div class="upload-section">
                <label class="section-label">上传简历文件</label>
                <div class="upload-area" 
                     :class="{ 'drag-over': isDragOver, 'has-file': uploadedFile, 'uploading': isUploading }"
                     @drop="!isUploading && handleDrop($event)"
                     @dragover.prevent="!isUploading && (isDragOver = true)"
                     @dragleave="isDragOver = false"
                     @click="!isUploading && triggerFileInput()">
                  <input ref="fileInput" 
                         type="file" 
                         accept=".pdf" 
                         @change="handleFileUpload" 
                         style="display: none">
                  <div v-if="isUploading" class="upload-placeholder">
                    <div class="upload-icon">
                      <i class="fas fa-spinner fa-spin"></i>
                    </div>
                    <p>正在上传中...</p>
                  </div>
                  <div v-else-if="!uploadedFile" class="upload-placeholder">
                    <div class="upload-icon">
                      <i class="fas fa-cloud-upload-alt"></i>
                    </div>
                    <p>点击或拖拽PDF文件于此</p>
                  </div>
                  <div v-else class="uploaded-file">
                    <div class="file-icon">
                      <i class="fas fa-file-pdf"></i>
                    </div>
                    <div class="file-details">
                      <h5 class="file-name">{{ uploadedFile.name }}</h5>
                      <p class="file-size">{{ formatFileSize(uploadedFile.size) }}</p>
                    </div>
                    <button class="remove-btn" @click.stop="removeFile">
                      <i class="fas fa-times"></i>
                    </button>
                  </div>
                </div>
              </div>
              
              <!-- 岗位JD输入区域 -->
              <div class="jd-section">
                <label class="section-label">目标岗位JD</label>
                <textarea 
                  v-model="jobDescription"
                  class="jd-textarea"
                  placeholder="请粘贴目标岗位的职位描述(JD)，AI将根据JD内容优化您的简历..."
                  rows="8"
                ></textarea>
                
                <!-- 优化按钮 -->
                <div class="button-group">
                  <button class="optimize-btn" 
                          :disabled="!uploadedFile || !jobDescription.trim() || isOptimizing"
                          @click="startOptimization">
                    <span v-if="isOptimizing">
                      <i class="fas fa-spinner fa-spin"></i>
                      AI正在优化中...
                    </span>
                    <span v-else>
                      <i class="fas fa-magic"></i>
                      开始AI优化
                    </span>
                  </button>
                  
                  <!-- 下载按钮 -->
                  <button v-if="optimizedResult" 
                          class="download-btn" 
                          @click="downloadOptimizedResume">
                    <i class="fas fa-download"></i>
                    下载优化后简历
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        
        <!-- Right Panel - Preview -->
        <div class="right-panel">
          <div class="preview-card">
            <div class="panel-header">
              <h5><i class="fas fa-eye"></i> 简历预览</h5>
              <div class="preview-controls">
                <button v-if="pdfUrl" 
                        class="btn btn-sm btn-outline-primary" 
                        @click="zoomOut">
                  <i class="fas fa-search-minus"></i>
                </button>
                <span v-if="pdfUrl" class="zoom-level">{{ Math.round(zoomLevel * 100) }}%</span>
                <button v-if="pdfUrl" 
                        class="btn btn-sm btn-outline-primary" 
                        @click="zoomIn">
                  <i class="fas fa-search-plus"></i>
                </button>
              </div>
            </div>
            
            <div class="preview-content">
              <div v-if="!pdfUrl" class="preview-placeholder">
                <i class="fas fa-file-pdf"></i>
                <h4>上传PDF文件开始预览</h4>
                <p class="text-muted">支持PDF格式的简历文件</p>
              </div>
              
              <div v-else class="pdf-viewer" :class="{ 'scanning': isOptimizing }">
                <VuePdfEmbed 
                  :source="pdfUrl" 
                  :page="currentPage"
                  :scale="zoomLevel"
                  @loaded="onPdfLoaded"
                />
                <!-- 蓝色扫光动画 -->
                <div v-if="isOptimizing" class="scan-line"></div>
                <div v-if="totalPages > 1" class="pdf-navigation">
                  <button 
                    class="btn btn-sm btn-outline-primary" 
                    :disabled="currentPage <= 1"
                    @click="currentPage--"
                  >
                    <i class="fas fa-chevron-left"></i>
                  </button>
                  <span class="page-info">{{ currentPage }} / {{ totalPages }}</span>
                  <button 
                    class="btn btn-sm btn-outline-primary" 
                    :disabled="currentPage >= totalPages"
                    @click="currentPage++"
                  >
                    <i class="fas fa-chevron-right"></i>
                  </button>
                </div>
              </div>
              
              <div v-if="optimizedResult" class="optimization-result">
                <div class="result-header">
                  <h6><i class="fas fa-check-circle text-success"></i> 优化完成</h6>
                  <div v-if="optimizedResult.score" class="score-badge">
                    <span class="badge badge-primary">评分: {{ optimizedResult.score }}/100</span>
                  </div>
                </div>
                
                <div class="result-content">
                  <div v-if="optimizedResult.improvements" class="mb-3">
                    <p><strong><i class="fas fa-star text-warning"></i> 已优化项目：</strong></p>
                    <ul class="improvement-list">
                      <li v-for="improvement in optimizedResult.improvements" :key="improvement">
                        <i class="fas fa-check text-success"></i> {{ improvement }}
                      </li>
                    </ul>
                  </div>
                  
                  <div v-if="optimizedResult.suggestions" class="mb-3">
                    <p><strong><i class="fas fa-lightbulb text-info"></i> 进一步建议：</strong></p>
                    <ul class="suggestion-list">
                      <li v-for="suggestion in optimizedResult.suggestions" :key="suggestion">
                        <i class="fas fa-arrow-right text-info"></i> {{ suggestion }}
                      </li>
                    </ul>
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Coze AI助手容器 -->
    <div id="coze-chat-container"></div>
    
  </div>
</template>

<script>
import Header from '../components/Header.vue'
import VuePdfEmbed from 'vue-pdf-embed'

export default {
  name: 'ResumeOptimizer',
  components: {
    Header,
    VuePdfEmbed
  },
  data() {
    return {
      uploadedFile: null,
      pdfUrl: null,
      isDragOver: false,
      jobDescription: '',
      zoomLevel: 1,
      currentPage: 1,
      totalPages: 0,
      isOptimizing: false,
      optimizedResult: null,
      isUploading: false,
      resumePublicUrl: null,

    }
  },
  methods: {
    triggerFileInput() {
      this.$refs.fileInput.click()
    },
    
    handleFileUpload(event) {
      const file = event.target.files[0]
      if (file) {
        this.processFile(file)
      }
    },
    
    handleDrop(event) {
      event.preventDefault()
      this.isDragOver = false
      
      const files = event.dataTransfer.files
      if (files.length > 0) {
        this.processFile(files[0])
      }
    },
    
    async processFile(file) {
      if (file.type !== 'application/pdf') {
        alert('请上传PDF格式的文件')
        return
      }
      
      if (file.size > 10 * 1024 * 1024) {
        alert('文件大小不能超过10MB')
        return
      }
      
      this.isUploading = true
      
      try {
        // 调用真实的上传接口
        await this.uploadResumeToServer(file)
        
        this.uploadedFile = file
        this.pdfUrl = URL.createObjectURL(file)
        this.currentPage = 1
        this.totalPages = 0
        this.optimizedResult = null
        this.optimizationProgress = 0
      } catch (error) {
        console.error('上传失败:', error)
        alert('上传失败，请稍后重试: ' + error.message)
      } finally {
        this.isUploading = false
      }
    },
    
    async uploadResumeToServer(file) {
      const formData = new FormData()
      formData.append('file', file)
      formData.append('upsert', 'false')
      
      const response = await fetch('http://211.159.149.77:9999/api/upload-original-resume/customer', {
        method: 'POST',
        body: formData
      })
      
      if (!response.ok) {
        const errorText = await response.text()
        throw new Error(`上传失败: ${response.status} ${response.statusText} - ${errorText}`)
      }
      
      const result = await response.json()
      console.log('上传成功:', result)
      
      // 保存后端返回的public_url
      if (result.public_url) {
        this.resumePublicUrl = result.public_url
      }
      
      return result
    },
    
    removeFile() {
      this.uploadedFile = null
      if (this.pdfUrl) {
        URL.revokeObjectURL(this.pdfUrl)
        this.pdfUrl = null
      }
      this.currentPage = 1
      this.totalPages = 0
      this.optimizedResult = null
      this.resumePublicUrl = null
    },
    
    formatFileSize(bytes) {
      if (bytes === 0) return '0 Bytes'
      const k = 1024
      const sizes = ['Bytes', 'KB', 'MB', 'GB']
      const i = Math.floor(Math.log(bytes) / Math.log(k))
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
    },
    
    zoomIn() {
      this.zoomLevel = Math.min(this.zoomLevel + 0.1, 2)
    },
    
    zoomOut() {
      this.zoomLevel = Math.max(this.zoomLevel - 0.1, 0.5)
    },
    
    async startOptimization() {
      if (!this.uploadedFile) {
        alert('请先上传简历文件')
        return
      }
      
      if (!this.jobDescription.trim()) {
        alert('请输入岗位JD描述')
        return
      }
      
      this.isOptimizing = true
      
      try {
        // 调用AI优化API
        const result = await this.callOptimizationAPI()
        
        // 处理优化结果，根据实际API响应结构解析数据
        if (result.code === 0 && result.data) {
          // 解析data字段中的JSON字符串
          const dataObj = JSON.parse(result.data)
          // 从output字段中提取PDF链接，去除反引号
          const pdfUrl = dataObj.output.trim().replace(/`/g, '')
          
          this.optimizedResult = {
            optimizedPdfUrl: pdfUrl
          }
          // 直接显示优化后的PDF
          this.pdfUrl = pdfUrl
          
          alert('简历优化完成！')
        } else {
          throw new Error('API返回数据格式错误')
        }
      } catch (error) {
        console.error('优化失败:', error)
        alert('优化失败，请稍后重试: ' + error.message)
      } finally {
        this.isOptimizing = false
      }
    },
    
    async callOptimizationAPI() {
      if (!this.resumePublicUrl) {
        throw new Error('简历文件尚未上传完成，请稍后重试')
      }
      
      // 调用Coze API
      const response = await fetch('https://api.coze.cn/v1/workflow/run', {
        method: 'POST',
        headers: {
          'Authorization': 'Bearer pat_n7FCUjqHk5txiwgiGoBRZu7Wjdoox9GQ8Ceyp2DTeJIMLbloCsDvAp5q4qsBmom9',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          workflow_id: '7541348120602755087',
          parameters: {
            jd: this.jobDescription,
            name: '测试',
            resume: this.resumePublicUrl
          }
        })
      })
      
      if (!response.ok) {
        const errorText = await response.text()
        throw new Error(`Coze API调用失败: ${response.status} ${response.statusText} - ${errorText}`)
      }
      
      const result = await response.json()
      return result
    },
    
    downloadOptimizedResume() {
      if (this.optimizedResult && this.optimizedResult.optimizedPdfUrl) {
        const link = document.createElement('a')
        link.href = this.optimizedResult.optimizedPdfUrl
        link.download = '优化后的简历.pdf'
        link.target = '_blank'
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
      } else {
        alert('暂无优化后的简历文件')
      }
    },
    
    viewOptimizedResume() {
      if (this.optimizedResult && this.optimizedResult.optimizedPdfUrl) {
        // 在预览区域显示优化后的简历
        this.pdfUrl = this.optimizedResult.optimizedPdfUrl
        this.currentPage = 1
        this.totalPages = 0
      }
    },
    
    onPdfLoaded(pdf) {
      this.totalPages = pdf.numPages
    },
    
    initCozeChat() {
      // 初始化Coze聊天界面
      if (window.CozeWebSDK) {
        try {
          // 创建Coze Web SDK实例
          const cozeWebSDK = new window.CozeWebSDK.WebChatClient({
            config: {
              // 智能体 ID - 需要替换为实际的Bot ID
              botId: '7539373245683220514', // 用户提供的bot ID
            },
            auth: {
              // 鉴权方式
              type: 'token',
              // 鉴权密钥 - 需要替换为实际的Token
              token: 'pat_n7FCUjqHk5txiwgiGoBRZu7Wjdoox9GQ8Ceyp2DTeJIMLbloCsDvAp5q4qsBmom9',
              // 备用密钥
              onRefreshToken: () => 'pat_n7FCUjqHk5txiwgiGoBRZu7Wjdoox9GQ8Ceyp2DTeJIMLbloCsDvAp5q4qsBmom9',
            },
            // 用户信息配置
            user: {
              id: 'user_' + Date.now(),
              nickname: '简历优化用户',
              url: 'https://via.placeholder.com/40x40'
            },
            // UI配置
            ui: {
              // 显示悬浮球，使用Coze自带的悬浮按钮
              floatButton: {
                show: true
              },
              // 聊天窗口配置
              chatWindow: {
                show: true,
                width: '350px',
                height: '500px'
              }
            }
          })
          
          // 将聊天界面渲染到指定容器
          const chatContainer = document.getElementById('coze-chat-container')
          if (chatContainer) {
            chatContainer.innerHTML = ''
            // SDK会自动在容器中渲染聊天界面
          }
        } catch (error) {
          console.error('初始化Coze SDK失败:', error)
        }
      } else {
        console.error('CozeWebSDK未加载')
      }
    }
  },
  
  mounted() {
    // 页面加载时自动初始化Coze聊天
    this.$nextTick(() => {
      this.initCozeChat()
    })
  },
  
  beforeUnmount() {
    if (this.pdfUrl) {
      URL.revokeObjectURL(this.pdfUrl)
    }
  }
}
</script>

<style scoped>
.resume-optimizer {
  min-height: 100vh;
  background: #ffffff;
  display: flex;
  flex-direction: column;
}

.main-container {
  flex: 1;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  padding: 20px;
  display: flex;
  align-items: center;
}

.content-wrapper {
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: 30px;
  width: 100%;
  max-height: calc(100vh - 140px);
  min-height: 600px;
}

.left-panel {
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.config-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  padding: 32px;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.card-header {
  text-align: center;
  margin-bottom: 32px;
}

.card-title {
  margin: 0;
  color: #2c3e50;
  font-weight: 700;
  font-size: 24px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.card-subtitle {
  color: #718096;
  font-size: 14px;
  margin: 8px 0 0 0;
}

.card-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 24px;
  min-height: 0;
  overflow-y: auto;
}

/* Upload Section */
.section-label {
  display: block;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 12px;
  font-size: 16px;
}

.upload-area {
  border: 2px dashed #e2e8f0;
  border-radius: 12px;
  padding: 12px 16px;
  text-align: center;
  transition: all 0.3s ease;
  cursor: pointer;
  background: #f8fafc;
  min-height: 60px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.upload-area:hover,
.upload-area.drag-over {
  border-color: #667eea;
  background: linear-gradient(135deg, #f0f4ff 0%, #faf5ff 100%);
  transform: translateY(-2px);
}

.upload-area.has-file {
  border-color: #48bb78;
  background: linear-gradient(135deg, #f0fff4 0%, #f0fff4 100%);
}

.upload-area.uploading {
  background: #fef3c7;
  border-color: #f59e0b;
  cursor: not-allowed;
}

.upload-area.uploading .upload-icon {
  color: #f39c12;
}

/* 蓝色扫光动画样式 */
.pdf-viewer {
  position: relative;
  overflow: hidden;
}

.pdf-viewer.scanning {
  position: relative;
}

.scan-line {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, transparent, #00bfff, #0080ff, #00bfff, transparent);
  box-shadow: 0 0 10px #00bfff, 0 0 20px #00bfff, 0 0 30px #00bfff;
  animation: scanAnimation 2s linear infinite;
  z-index: 10;
}

@keyframes scanAnimation {
  0% {
    top: 0;
    opacity: 1;
  }
  50% {
    opacity: 0.8;
  }
  100% {
    top: 100%;
    opacity: 1;
  }
}

.upload-icon {
  font-size: 24px;
  color: #667eea;
  margin-bottom: 8px;
}

.upload-placeholder p {
  color: #2c3e50;
  margin: 0;
  font-size: 14px;
  font-weight: 500;
}

.upload-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.uploaded-file {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px 20px;
  background: linear-gradient(135deg, #f0fff4 0%, #f0fff4 100%);
  border: 2px solid #48bb78;
  border-radius: 12px;
}

.file-icon {
  font-size: 24px;
  color: #48bb78;
}

.file-details {
  flex: 1;
  text-align: left;
}

.file-name {
  margin: 0 0 4px 0;
  font-weight: 600;
  color: #2c3e50;
  font-size: 16px;
}

.file-size {
  margin: 0;
  color: #718096;
  font-size: 14px;
}

.remove-btn {
  background: #e53e3e;
  border: none;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  color: white;
  cursor: pointer;
  transition: all 0.2s ease;
}

.remove-btn:hover {
  background: #c53030;
  transform: scale(1.1);
}

/* JD Section */
.jd-section {
  display: flex;
  flex-direction: column;
  margin-bottom: 20px;
}

.jd-section .optimize-btn {
  margin-top: 16px;
  width: 100%;
}

.jd-textarea {
  width: 100%;
  min-height: 120px;
  max-height: 200px;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  padding: 16px;
  font-size: 14px;
  line-height: 1.6;
  resize: vertical;
  transition: all 0.3s ease;
  font-family: inherit;
}

.jd-textarea:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
}

/* Action Section */
.action-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #f1f5f9;
}

.button-group {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.optimize-btn {
  flex: 1;
  min-width: 160px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  border-radius: 16px;
  padding: 18px 32px;
  color: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.optimize-btn:hover:not(:disabled) {
  transform: translateY(-3px);
  box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
}

.optimize-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.progress-section {
  text-align: center;
}

.progress-bar {
  width: 100%;
  height: 8px;
  background: #e2e8f0;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 8px;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
  border-radius: 4px;
  transition: width 0.3s ease;
}

.progress-text {
  margin: 0;
  color: #667eea;
  font-weight: 600;
  font-size: 14px;
}

.download-btn {
  flex: 1;
  min-width: 160px;
  background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
  border: none;
  border-radius: 16px;
  padding: 18px 32px;
  color: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.download-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 35px rgba(40, 167, 69, 0.4);
}

/* Right Panel */
.right-panel {
  flex: 1;
  min-width: 0;
}

/* Preview Card */
.preview-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  padding: 32px;
  display: flex;
  flex-direction: column;
  height: 100%;
  overflow: hidden;
}

.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 2px solid #f1f3f4;
}

.panel-header h5 {
  margin: 0;
  color: #2c3e50;
  font-weight: 700;
  font-size: 20px;
}

.panel-header i {
  color: #667eea;
  margin-right: 8px;
}

.preview-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.btn {
  border: none;
  border-radius: 8px;
  padding: 8px 16px;
  font-size: 14px;
  background: white;
  color: #4a5568;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.btn:hover {
  background: #667eea;
  color: white;
  transform: translateY(-1px);
}

.zoom-level {
  font-size: 14px;
  color: #4a5568;
  font-weight: 600;
  min-width: 60px;
  text-align: center;
}

.preview-content {
  flex: 1;
  position: relative;
  overflow: hidden;
}

.preview-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #6c757d;
}

.preview-placeholder i {
  font-size: 64px;
  margin-bottom: 16px;
  opacity: 0.5;
}

.preview-placeholder h4 {
  margin: 0 0 8px 0;
  font-size: 18px;
}

.preview-placeholder p {
  margin: 0;
  font-size: 14px;
}

.pdf-viewer {
  width: 100%;
  height: 100%;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  overflow: auto;
  background: #f8fafc;
}

.pdf-navigation {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  margin-top: 16px;
  padding: 12px 20px;
  background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
  border-radius: 12px;
}

.page-info {
  font-size: 14px;
  color: #4a5568;
  font-weight: 600;
  min-width: 80px;
  text-align: center;
}

.optimization-result {
  position: absolute;
  top: 20px;
  right: 20px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
  padding: 24px;
  max-width: 350px;
  z-index: 10;
  border: 2px solid #e6fffa;
}

.result-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.result-header h6 {
  margin: 0;
  color: #27ae60;
  font-size: 18px;
  font-weight: 700;
}

.score-badge .badge {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
}

.result-content ul {
  margin: 0;
  padding-left: 20px;
}

.result-content li {
  margin-bottom: 8px;
  font-size: 14px;
  color: #2c3e50;
  line-height: 1.5;
}

.improvement-list li i,
.suggestion-list li i {
  margin-right: 8px;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .content-wrapper {
    grid-template-columns: 1fr;
    gap: 20px;
    height: auto;
  }
  
  .config-card,
  .preview-card {
    height: auto;
    min-height: 500px;
  }
}

/* Coze AI助手容器样式 */
#coze-chat-container {
  /* 容器样式由Coze SDK自动管理 */
}

@media (max-width: 768px) {
  .resume-optimizer {
    padding: 10px;
  }
  
  .config-card,
  .preview-card {
    padding: 24px;
    margin-bottom: 20px;
  }
  
  .preview-controls {
    flex-wrap: wrap;
    gap: 8px;
  }
  
  .optimization-result {
    position: relative;
    top: auto;
    right: auto;
    margin-top: 20px;
    max-width: none;
  }
  
  .button-group {
    flex-direction: column;
  }
  
  .optimize-btn, .download-btn {
    width: 100%;
    min-width: auto;
  }
}
</style>