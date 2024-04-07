#!/bin/bash

# Init git repository
git init

# Init Node.js project
npm init -y

# Install dependencies
npm i -D commitizen standard husky ava sinon c8 typescript --silent

# Initialize Commitizen with cz-conventional-changelog adapter
npx commitizen init cz-conventional-changelog --save-dev --save-exact

# Create .czrc configuration file
echo '{ "path": "cz-conventional-changelog" }' > .czrc

# Create ava.config.js file
echo "export default {
  files: [
    'test/**/*.spec.js'
  ]
}" > ava.config.js

# Set npm package scripts
npm pkg set type='module'
npm pkg set license='MIT'
npm pkg set scripts.build:types="tsc -p tsconfig-build-types.json"
npm pkg set scripts.check:types="tsc"
npm pkg set scripts.check:types:watch="tsc --watch"
npm pkg set scripts.coverage="c8 --reporter=lcov ava"
npm pkg set scripts.coverage:view="c8 --reporter=html --reporter=text ava"
npm pkg set scripts.lint="standard"
npm pkg set scripts.lint:fix="standard --fix"
npm pkg set scripts.release:first="npm run release -- --first-release"
npm pkg set scripts.test="ava"
npm pkg set scripts.test:watch="ava --watch"
npm pkg set standard.includes='["test"]' --json

# Run prepare script
npx husky init

# Add husky hooks
echo "npm run lint" > .husky/pre-commit
echo "npm test" >> .husky/pre-commit
echo "exec < /dev/tty && node_modules/.bin/cz --hook || true" >> .husky/prepare-commit-msg

mkdir test
echo "import test from 'ava'

test('initial setup', async t => {
  t.pass()
})" > test/initial-setup.spec.js

echo '{
  "compilerOptions": {
  "allowJs": true,
  "allowSyntheticDefaultImports": true,
  "alwaysStrict": true,
  "checkJs": true,
  "esModuleInterop": true,
  "lib": [
    "ESNext"
  ],
  "module": "NodeNext",
  "noEmit": true,
  "noImplicitThis": true,
  "strict": true,
  "strictNullChecks": true,
  "target": "ESNext"
  },
  "exclude": [
    "node_modules"
  ],
  "include": [
    "test",
    "src"
  ]
}' > tsconfig.json

echo '{
  "extends": "./tsconfig",
  "compilerOptions": {
    "declaration": true,
    "declarationDir": "./types",
    "emitDeclarationOnly": true,
    "noEmit": false
  },
  "include": [
    "src"
  ]
}' > tsconfig-build-types.json
