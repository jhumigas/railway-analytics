.PHONY: docker-up
docker-up: ## Start the Docker containers in detached mode
	docker compose --env-file .env -f docker/docker-compose.yml up -d

.PHONY: docker-down
docker-down: ## Stop and remove the Docker containers
	docker compose --env-file .env -f docker/docker-compose.yml down

.PHONY: install
install: ## install dependencies
	uv sync --locked --all-extras --dev