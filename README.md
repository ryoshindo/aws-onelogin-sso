# aws-onelogin-sso

OneLoginからAWSへSAMLでSSOするための設定をTerraformで行うためのリポジトリです。

## 必要なもの
- OneLogin Credentials：Manage All権限が付与されたCredentials
- AWS Credentials：管理者権限（最低権限は調査していません）


## 設定
1. AWS Credentialsを入力してください。

2. 以下のコマンドを実行してください。
    ```shell
    $ export ONELOGIN_CLIENT_ID=<your client id>
    $ export ONELOGIN_CLIENT_SECRET=<your client secret>
    $ export ONELOGIN_OAPI_URL=<the api url for your region>
    $ cd terraform
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```