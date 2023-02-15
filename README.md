#  Public and private files in S3

Example of storing public and private files in single S3 bucket exposed by CloudFront

## Main assumptions

- direct access to the S3 bucket is forbidden, files are available only via CloudFront
- files are private by default - only files with `/public` prefix are public
- the pre-signed url will be used to give access to the private file
- S3 and CloudFront deployment is handled by Terraform
