echo "🔨  Cheking Xcode installation"
xcode-select -p
if [[ $? =~ "error" ]] ; then
    # Missing Xcode Command Line Tools
    echo "❌  Missing Xcode installation, please install and select"
    exit 1
fi

echo "🍺  Checking Brew"
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "💎  Checking Ruby bundler"
which -s bundle
if [[ $? != 0 ]] ; then
    # Install Bundler
    sudo gem install bundler
fi

brew tap phrase/brewed
brew install phrase
brew install git-lfs
bundle install
bundle exec pod install
