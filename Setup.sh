# Run this scrip is only needed the first time the project is cloned. After that, there's no need to run it again unless
# some content of it is changed.

# Xcode Command Line Tools:
xcode-select --install

# Homebrew:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

read -p  "IF THERE ARE INSTRUCTIONS ABOVE ^ REGARDING THE INCLUSION OF HOMEBREW TO YOUR PATH, DO IT NOW IN ANOTHER TERMINAL AND THEN CONTINUE." -n1 -s
echo ""

eval "$(/opt/homebrew/bin/brew shellenv)"

# Xcodes (manages the versions of Xcode, used by some lanes):
brew install xcodesorg/made/xcodes

# rbenv (manages the Ruby environment used by some of the requirements, like Fastlane):
brew install rbenv ruby-build

echo ""
echo "====================================="
echo "====================================="
rbenv init
echo "====================================="
echo "====================================="
echo ""
read -p  "DO THESE MANUAL STEPS ABOVE ^ AND THEN CONTINUE. ('profile' may be the ./.zshrc file and / or ./.bash_profile.)" -n1 -s
echo ""

eval "$(rbenv init - sh)"

# Ruby dependencies:
brew install openssl@3 readline libyaml gmp

# Ruby:
rbenv install 3.3.0

rbenv local 3.3.0

ruby -v

# Fastlane:
gem install fastlane -v 2.219.0

# Secrets:
echo "====================================="
echo "SECRETS CONFIGURATION"
echo "====================================="
read -p "Enter the API key for TMDB (https://www.themoviedb.org/settings/api): " tmdbApiKey
echo "TMDB-API-KEY=$tmdbApiKey" > .env

# Finish:
echo "====================================="
echo "Finished."
echo "It is recommended to restart the Terminal app before continue using it."
echo "====================================="
