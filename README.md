# Cherry 백엔드 개발환경 가이드 📚

프론트엔드 개발을 위한 백엔드 API 서버 실행 가이드입니다.

## 🚀 빠른 시작

### 1. 파일 다운로드
```bash
# 이 레포지토리 클론 또는 파일 다운로드
git clone [backend-dev-env-repo]
cd cherry-backend-dev
```

### 2. 환경변수 설정
`env` 파일의 값들을 Discord에서 공유드린 실제 값으로 교체해주세요.

### 3. 백엔드 서버 실행
```bash
# 모든 서비스 백그라운드 실행 (백엔드 + DB + Redis)
docker-compose up -d
docker-compose up # 터미널에서 로그까지 바로 보는 포어그라운드 실행

# 로그 확인
docker-compose logs -f cherry-backend
```

### 4. 실행 확인
- **API 서버**: http://localhost:8080
- **Health Check**: http://localhost:8080/actuator/health
- **Swagger UI**: http://localhost:8080/swagger-ui/index.html

### 5. 데이터 보존 안내
DB 데이터는 자동으로 보존됩니다.

- 컴퓨터를 껐다 켜도 MySQL, Redis 데이터 유지
- `docker-compose stop`, `docker-compose down` 해도 데이터 유지

데이터를 완전히 삭제하고 싶을 때:
``` bash
docker-compose down -v  # 볼륨까지 삭제
```

## 🔄 업데이트 방법

최신 백엔드 코드로 업데이트하려면:

```bash
# 자동 업데이트 스크립트 실행
chmod +x update-backend.sh # 이 스크립트를 직접 실행 가능하도록 권한 추가 (처음 한번만)
./update-backend.sh

# 또는 수동 업데이트
docker-compose pull cherry-backend
docker-compose up -d cherry-backend
```

## 📊 서비스 정보

| 서비스 | 포트 | 접근 URL |
|-------|------|----------|
| 백엔드 API | 8080 | http://localhost:8080 |
| MySQL | 3306 | localhost:3306 |
| Redis | 6379 | localhost:6379 |

### 데이터베이스 정보
- **Database**: cherry
- **Username**: myuser
- **Password**: secret

## 🛠️ 유용한 명령어

```bash
# 모든 서비스 시작
docker-compose up -d

# 백엔드만 재시작
docker-compose restart cherry-backend

# 로그 확인
docker-compose logs -f cherry-backend

# 전체 정리 (데이터 삭제됨)
docker-compose down -v

# 백엔드 상태 확인
curl http://localhost:8080/actuator/health
```

## 💬 문제 해결

### 포트 충돌
이미 사용 중인 포트가 있다면:

**macOS/Linux**
```bash
# 1. 실행 중인 프로세스 확인
lsof -i :8080
lsof -i :3306
lsof -i :6379

# 2. 충돌하는 프로세스 종료 (PID 확인 후)
kill -9 [PID번호]

# 예시: PID가 1234인 경우
kill -9 1234
```

**Window**
```bash
# 1. 실행 중인 프로세스 확인
netstat -ano | findstr :8080
netstat -ano | findstr :3306
netstat -ano | findstr :6379

# 2. 충돌하는 프로세스 종료 (PID 확인 후)
taskkill /PID [PID번호] /F

# 예시: PID가 1234인 경우
taskkill /PID 1234 /F
```

**프로세스 다시 실행**
```bash
docker-compose up -d
```

### 백엔드 서버가 시작되지 않을 때
```bash
# 컨테이너 상태 확인
docker-compose ps

# 상세 로그 확인
docker-compose logs cherry-backend

# 전체 재시작
docker-compose down
docker-compose up -d
```

### 데이터베이스 연결 오류
```bash
# MySQL 상태 확인
docker-compose logs mysql

# 헬스체크 확인
docker-compose ps
```

## 📝 API 테스트

### Swagger UI 사용
브라우저에서 http://localhost:8080/swagger-ui/index.html 접속

### cURL 예시
```bash
# Health Check
curl http://localhost:8080/actuator/health

# API 예시 (실제 엔드포인트에 맞게 수정)
curl -X GET http://localhost:8080/api/users \
  -H "Content-Type: application/json"
```

## ⚠️ 주의사항

1. **첫 실행시**: MySQL 초기화에 1-2분 소요됩니다.
2. **데이터 보존**: `docker-compose down -v`를 실행하면 DB 데이터가 삭제됩니다.
3. **메모리 사용량**: 전체 서비스 실행시 약 1GB 메모리를 사용합니다.