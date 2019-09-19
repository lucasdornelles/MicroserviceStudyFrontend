#!bin/bash
echo "Preparing slug contents"
mkdir app
cp -r ./build ./app

echo "Creating slug archive"
tar -czf slug.tgz ./app

echo "Creating slug object"
_heroku_deploy_apikey=`echo "${HEROKU_API_KEY}" | base64`
_heroku_deploy_createSlugResponse=$(curl -X POST \
-H "Content-Type: application/json" \
-H "Accept: application/vnd.heroku+json; version=3" \
-H "Authorization: ${_heroku_deploy_apiKey}" \
-d '{"process_types":{ "web": "node-v0.10.20-linux-x64/bin/node web.js" }}' \
-n https://api.heroku.com/apps/${HEROKU_APP_NAME_STAGE}/slugs)

function _heroku_deploy_parseField {
  echo -ne $2 | grep -o "\"$1\"\s*:\s*\"[^\"]*\"" | head -1 | cut -d '""' -f 4
}

_heroku_deploy_blobUrl=$(_heroku_deploy_parseField "url" "'${_heroku_deploy_createSlugResponse}'")
_heroku_deploy_blobMethod=$(_heroku_deploy_parseField "method" "'${_heroku_deploy_createSlugResponse}'")
_heroku_deploy_slugId=$(_heroku_deploy_parseField "id" "'${_heroku_deploy_createSlugResponse}'")

echo "Uploading slug archive"
curl -X ${_heroku_deploy_blobMethod^^} -H "Content-Type:" --data-binary @slug.tgz ${_heroku_deploy_blobUrl}

function deployToHeroku { #Args: application name
  curl -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3" \
  -H "Authorization: ${_heroku_deploy_apiKey}" \
  -d "{\"slug\":\"${_heroku_deploy_slugId}\"}" \
  -n https://api.heroku.com/apps/$1/releases
}

echo "Deploying slug to stage"
deployToHeroku ${HEROKU_APP_NAME_STAGE}
