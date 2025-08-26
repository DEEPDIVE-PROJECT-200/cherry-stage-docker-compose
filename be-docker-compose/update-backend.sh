#!/usr/bin/env bash

echo "🔄 Cherry 백엔드 업데이트를 시작합니다..."

# 색깔 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 에러 핸들링
set -e

# 함수: 에러 발생시 실행
error_exit() {
    echo -e "${RED}❌ 업데이트 중 오류가 발생했습니다: $1${NC}" >&2
    exit 1
}

# 함수: Docker Compose 파일 존재 확인
check_docker_compose() {
    if [ ! -f "docker-compose.yml" ]; then
        error_exit "docker-compose.yml 파일을 찾을 수 없습니다."
    fi
}

# 함수: 백엔드 서비스 상태 확인
check_backend_status() {
    local max_attempts=30
    local attempt=1
    
    echo -e "${BLUE}⏳ 백엔드 서비스 시작을 기다리는 중...${NC}"
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f -s http://localhost:8080/api/v1/health > /dev/null 2>&1; then
            echo -e "${GREEN}✅ 백엔드 서비스가 정상적으로 시작되었습니다!${NC}"
            return 0
        fi
        
        echo -e "시도 $attempt/$max_attempts - 2초 후 재시도..."
        sleep 2
        ((attempt++))
    done
    
    error_exit "백엔드 서비스 시작 시간이 초과되었습니다. 로그를 확인해주세요."
}

# 메인 업데이트 프로세스
main() {
    # Docker Compose 파일 존재 확인
    check_docker_compose
    
    # 최신 이미지 가져오기
    echo -e "${BLUE}📦 최신 백엔드 이미지를 다운로드하는 중...${NC}"
    docker-compose pull cherry-backend || error_exit "이미지 다운로드 실패"
    
    # 백엔드 서비스만 재시작
    echo -e "${BLUE}🔄 백엔드 서비스를 재시작하는 중...${NC}"
    docker compose pull cherry-backend || error_exit "이미지 다운로드 실패"
    docker compose stop cherry-backend || true
    docker compose rm -f cherry-backend || true
    sleep 2 # 잠시 대기 
    docker compose up -d --no-deps cherry-backend || error_exit "백엔드 서비스 시작 실패"
    
    # 서비스 상태 확인
    check_backend_status
    
    # 완료 메시지
    echo -e "${GREEN}🎉 백엔드 업데이트가 완료되었습니다!${NC}"
    echo ""
    echo "📋 접속 정보:"
    echo "   • API 서버: http://localhost:8080"
    echo "   • Health Check: http://localhost:8080/api/v1/health"
    echo "   • Swagger UI: http://localhost:8080/api/v1/swagger-ui/index.html"
    echo ""
    echo "📊 로그 확인: docker-compose logs -f cherry-backend"
}

# 스크립트 실행
main "$@"