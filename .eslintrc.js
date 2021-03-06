const jsConfig = require('./jsconfig').compilerOptions;
const path = require('path');
const projectRootPath = __dirname;
const packageJson = require(path.join(projectRootPath, 'package.json'));

const pathsConfig = jsConfig.paths;
let voltoPath = './node_modules/@plone/volto';
Object.keys(pathsConfig).forEach(pkg => {
  if (pkg === '@plone/volto') {
    voltoPath = `./${jsConfig.baseUrl}/${pathsConfig[pkg][0]}`;
  }
});

const AddonConfigurationRegistry = require(`${voltoPath}/addon-registry.js`);
const reg = new AddonConfigurationRegistry(__dirname);

// Extends ESlint configuration for adding the aliases to `src` directories in Volto addons
const addonAliases = Object.keys(reg.packages).map(o => [
  o,
  reg.packages[o].modulePath,
]);

// console.log('eslint search path', `${projectRootPath}/src/addons/searchlib/packages/searchlib`);

module.exports = {
  extends: `${projectRootPath}/node_modules/@plone/volto/.eslintrc`,
  settings: {
    'import/resolver': {
      alias: {
        map: [
          ['@plone/volto', '@plone/volto/src'],
          ...addonAliases,
          ['@package', `${__dirname}/src`],
          ['~', `${__dirname}/src`],
          ['@eeacms/search', `${projectRootPath}/src/addons/searchlib/packages/searchlib`],
          ['@eeacms/globalsearch', `${projectRootPath}/src/addons/searchlib/packages/searchlib-globalsearch/src`],
          ['@eeacms/search-less', `${projectRootPath}/src/addons/searchlib/packages/searchlib-less`],
        ],
        extensions: ['.js', '.jsx', '.json'],
      },
      'babel-plugin-root-import': {
        rootPathSuffix: 'src',
      },
    },
  },
};
