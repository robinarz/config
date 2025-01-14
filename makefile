CONFIG_HOME := $(HOME)/.config/
ZPLUG_HOME := $(CONFIG_HOME)/zplug
ZSH_HOME := $(CONFIG_HOME)/zplug
ZSH_ENV_HOME := $(HOME)/
NVIM_HOME := $(CONFIG_HOME)/nvim
SCRIPTS_DIR := ./scripts

help: ## Print help message
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\033[36m\1\\033[m:\2/' | column -c2 -t -s :)"

install: export CONFIG_HOME = $(CONFIG_HOME)
install: export ZPLUG_HOME = $(ZPLUG_HOME)
install: export ZSH_HOME = $(ZSH_HOME)
install: export ZSH_ENV_HOME = $(ZSH_ENV_HOME)
install: ## Install dotfiles
	@echo "Installing dotfiles..."
	.$(SCRIPTS_DIR)/links.sh


.PHONY: all zsh nvim build_reqs pkgs dev_tools docker treesitter tools

all: dirs build_reqs zsh nvim pkgs docker mise dev_tools treesitter tools
	@echo "All done"

zsh: ## Install zsh and setup as default shell
	@echo "========================================"
	@echo "Installing Zsh..."
	sudo apt install zsh -y
	chsh -s $(shell which zsh)
	@echo "========================================"

dirs: ## Create directories
	mkdir -p ~/git
	mkdir -p ~/build

build_reqs: ## Packages requirements
	# Update the system
	sudo apt update

	# Install required packages
	sudo apt install -y make cmake git \
		gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip \
		make build-essential libssl-dev zlib1g-dev libbz2-dev \
		libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
		xz-utils tk-dev libffi-dev liblzma-dev git ffmpeg

pkgs: ## Install other important packages
	sudo apt install -y ripgrep fzf jq \
		pass dnsutils pwgen flameshot btop rsync

nvim: dirs build_reqs ## Build Neovim from source
	if [ -d ~/build/neovim ]; then cd ~/build/neovim && git pull; else git clone https://github.com/neovim/neovim ~/build/neovim; fi
	cd ~/build/neovim/ && make -j2 -s --no-print-directory && sudo make install -s

dev_tools: ## Install devtools
	@echo "Installing dev-tools..."
	$(SCRIPTS_DIR)/devtools.sh

mise: ## Install mise
	@echo "Checking if mise is installed..."
	@command -v $(HOME)/.local/mise >/dev/null 2>&1 || { \
		echo "Error: mise is not installed. Please install it first."; \
		exit 1; \
	}
	@echo "Installing mise..."
	curl https://mise.run | sh

docker: ## Install Docker engine
	$(SCRIPTS_DIR)/docker.sh

treesitter: ## Install treesitter-cli with cargo as it's needed for nvim
	@echo "Checking if cargo is installed..."
	@command -v cargo >/dev/null 2>&1 || { \
		echo "Error: cargo is not installed. Please install Rust and Cargo first."; \
		exit 1; \
	}
	@echo "Installing treesitter-cli through cargo..."
	cargo install tree-sitter-cli

tools: ## Installing some tools that use through cargo
	@echo "Installing tools through cargo..."
	cargo install git-delta tokei
