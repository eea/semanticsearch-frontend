
## Release new version

 - if modifications were done in [volto-searchlib](https://github.com/eea/volto-searchlib), create a new release of it (`git tag`)
 -  in package.json -> dependencies update *@eeacms/volto-searchlib* to point to the release created in the previous step (ex: `"@eeacms/volto-searchlib": "eea/volto-searchlib#v0.1.15"`)
 - release the new version of semanticsearch-frontend (`git tag`)
