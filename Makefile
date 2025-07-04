# Load environment variables (e.g., RPC urls, keys)
-include .env

TEST_ARGS=
DEPLOY_ARGS=
ACCOUNT_NAME=deployWallet

# Default target
.DEFAULT_GOAL := help
#######################
### Core Operations ###
#######################

# Clean and build
build:
	@echo "🔨 Compiling contracts..."
	forge build

# Run all tests (unit + fuzz + invariant)
test:
	@echo "🧪 Running all tests..."
	forge test $(TEST_ARGS) -vv

# Run only fuzz tests
fuzz:
	@echo "🎲 Fuzz & invariant tests..."
	forge test --match-path "test/fuzz/*" $(TEST_ARGS) -vv

# Run tests against a mainnet fork for on-chain integration
test-fork:
	@echo "🌐 Testing on a mainnet fork..."
	forge test --fork-url $(MAINNET_RPC_URL) --fork-block-number $(FORK_BLOCK) -vv

# Format & lint
fmt:
	@echo "🧹 Formatting code..."
	forge fmt

analyze:
	@echo "🔍 Analyzing code..."
	slither .

#########################
### Deployment Options ###
#########################

# Default deploy (anvil or testnet/mainnet via ARGS)
deploy:
	@echo "🚀 Deploying"
	forge script script/Deploy.s.sol:Deploy $(DEPLOY_ARGS) --broadcast

deploy-anvil:
	@echo "🚀 Deploying to local anvil..."
	if [ -z "$$ANVIL_KEY" ]; then \
		echo "⚠️ Anvil key is not set. Set ANVIL_KEY in .env file."; \
		exit 1; \
	fi
	forge script script/Deploy.s.sol:Deploy --rpc-url http://127.0.0.1:8545 --broadcast  --account $(ACCOUNT_NAME)

deploy-sepolia:
	@echo "🚀 Deploying to Sepolia..."
	if [ -z "$$SEPOLIA_RPC_URL" ]; then \
		echo "⚠️ Sepolia RPC Url is not set. Set SEPOLIA_RPC_URL in .env file."; \
		exit 1; \
	fi
	if [ -z "$$ETHERSCAN_API_KEY" ]; then \
		echo "⚠️ Etherscan API key is not set. Set ETHERSCAN_API_KEY in .env file."; \
		exit 1; \
	fi
	forge script script/Deploy.s.sol:Deploy --rpc-url $(SEPOLIA_RPC_URL)  --account $(ACCOUNT_NAME) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy-mainnet:
	@echo "🚀 Deploying to Ethereum mainnet..."
	forge script script/Deploy.s.sol:Deploy --rpc-url $(MAINNET_RPC_URL)  --account $(ACCOUNT_NAME) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

###################
### Diagnostics ###
###################

gas-report:
	@echo "💰 Generating gas usage report..."
	forge test --gas-report

clean:
	@echo "🧼 Cleaning generated files..."
	forge clean
	rm -rf out cache

###################
### Help Section ###
###################
help:
	@echo "Usage:"
	@echo "  make build             - Compile contracts"
	@echo "  make test              - Run full test suite"
	@echo "  make fuzz              - Run fuzz + invariant tests"
	@echo "  make test-fork         - Run tests on mainnet fork"
	@echo "  make fmt               - Format code"
	@echo "  make analyze           - Run static analysis"
	@echo "  make deploy            - Deploy with args"
	@echo "  make deploy-anvil      - Deploy locally"
	@echo "  make gas-report        - Capture gas costs (fork)"
	@echo "  make clean             - Clean build artifacts"

.PHONY: build test fuzz fork fmt lint deploy deploy-anvil deploy-sepolia deploy-mainnet gas-report clean help
