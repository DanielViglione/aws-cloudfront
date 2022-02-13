SFTP_CLIENT_BUCKET=$1
cd "$(dirname "$(realpath "$0")")"
npm run build
aws s3 sync build s3://$SFTP_CLIENT_BUCKET/ --delete