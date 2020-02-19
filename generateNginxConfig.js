const fs = require('fs');
const NGINX_SITES_AVAILABLE = '/etc/nginx/sites-available/';
const NGINX_SITES_ENABLED = '/etc/nginx/sites-enabled/';
// Replace on production 
const NGINX_TEMP_PATH = '/home/daviid/Projects/automation-shell-scripts/nginxTmp.txt';
const port = process.argv[2];
const projectName = process.argv[3];
const projectEnvPath= `${process.argv[4]}`;
const projectNginXFilePath = `${NGINX_SITES_AVAILABLE}${projectName}`;
const exec = require('child_process').exec;


// check if file exist to delete it
fs.access(`${projectNginXFilePath}`, (notFound)=>{
    if (!notFound) {
        // file found
        console.log('File Found');
        // delete config file
        fs.unlink(`${projectNginXFilePath}`, (err)=> {
           if(err) throw err;
           else console.log('File was found and deleted successfully');
        });
    }
    // read env file to get domain name 
    fs.readFile(`${projectEnvPath}`, 'utf8', (err, data) => {
        if (err) throw err;
        const start = data.search('domain');

        if(start<0) throw new Error('Domain don\'t exist in your production env');
        const subString = data.substring(start);
        const domainLine = Math.max(subString.search('com') ,subString.search('org') ); ;
        console.log(domainLine)
        // domain name 
        const domain = subString.substring(0, domainLine + 4).split(':')[1].split('\'')[1] || subString.substring(0, domainLine + 4).split(':')[1].split('\"')[1] ;
        console.log(domain);
        // temp config path 
        fs.readFile(`${NGINX_TEMP_PATH}`, 'utf8', (err, data) => {
            if (err) throw err;
            // replace the domain and the port
            const content = data.replace(new RegExp('REPLACETOKENDOMAIN', 'g'), domain);
            const nginxFileContent = content.replace(new RegExp('REPLACETOKENPORT', 'g'), port);
            // write the new file 
            fs.writeFile(`${projectNginXFilePath}`, nginxFileContent, 'utf8', function(err) {
              if (err) throw err;
              // init the synbolic link 
              exec(`ln -s ${projectNginXFilePath} ${NGINX_SITES_ENABLED}`, (err) =>{
                   if (err) throw err;
                });
              console.log('Synbolic link registered');
              exec(`service nginx restart`, (err) =>{
                if (err) throw err;
             });
              console.log('Nginx Restarted');

              process.exit();
            });
          });
    })
});


