import yargs from 'yargs/yargs';
import { getSignedUrl } from "@aws-sdk/cloudfront-signer";
import { readFile } from 'node:fs/promises';

const args = await yargs(process.argv.slice(2))
    .wrap(120)
    .version(false)
    .usage('Example usage:')
    .usage('npm run getFileUrl -- --pki XXX --pkp XXX --cfd example.com --ok sample.jpg --ttl 3600')
    .options({
        publicKeyId: {
            alias: 'pki',
            type: 'string',
            demandOption: true,
        },
        privateKeyPath: {
            alias: 'pkp',
            type: 'string',
            demandOption: true,
        },
        cloudFrontDomain: {
            alias: 'cfd',
            type: 'string',
            demandOption: true,
        },
        objectKey: {
            alias: 'ok',
            type: 'string',
            demandOption: true,
        },
        timeToLive: {
            alias: 'ttl',
            type: 'number',
            description: 'Signed URL expiration in seconds',
            demandOption: true,
        },
    })
    .help()
    .alias('h', 'help')
    .parse();

const privateKey = await readFile(args.privateKeyPath)

const signedUrl = getSignedUrl({
    keyPairId: args.publicKeyId,
    privateKey: privateKey,
    url: `https://${args.cloudFrontDomain}/${args.objectKey}`,
    dateLessThan: new Date(Date.now() + args.timeToLive).toISOString(),
});

console.log(signedUrl);
