/**
 * This is needed for Slack 4.x, since the `ssb-interop.js` is no
 * longer available for hooking.
 */
const dedent = require("dedent");
const fs = require("fs");
const { exec, spawn } = require("child_process");


function main() {
    const resources = "/Applications/Slack.app/Contents/Resources";
    createBackup(resources).then(() => {
        //  TODO: Force close the application, before injecting.
        //        We might be able to see whether it's running by just using
        //        `ps aux | grep`
        return inject(resources);
    }).then(() => {
        console.log("Done!");
        exec("open /Applications/Slack.app", {
            env: {
                SLACK_DEVELOPER_MENU: true,
            },
        });
    }).catch((err) => {
        console.error(`error: ${err}`);
    });
}

/**
 * @param {string} resources path to Slack resources
 * @return {Promise}
 */
function createBackup(resources) {
    return new Promise((resolve, reject) => {
        let promise;
        if (!fs.existsSync(`${resources}/app.asar.orig`)) {
            console.log("Making backup...");
            promise = call(
                "cp",
                [
                    `${resources}/app.asar`,
                    `${resources}/app.asar.orig`,
                ]
            ).catch((err) => {
                reject(err);    
            });
        } else {
            console.log("Restoring untainted file...");
            //  Use original file, since the newly bundled file will have
            //  the custom CSS already injected.
            promise = call(
                "cp",
                [
                    `${resources}/app.asar.orig`,
                    `${resources}/app.asar`,
                ],
            ).catch((err) => {
                reject(err);
            });
        }

        promise.then(resolve);
    });
}

/**
 * @param {string} resources path to Slack resources
 * @return {Promise}
 */
function inject(resources) {
    console.log("Unpacking...");
    return call(
        "npx",
        [
            "asar",
            "extract",
            `${resources}/app.asar`,
            `${resources}/app.asar.unpacked`,
        ],
    ).then(() => {
        console.log("Injecting...");
        fs.appendFileSync(
            `${resources}/app.asar.unpacked/dist/ssb-interop.bundle.js`,
            "\n" + constructPayload(),
        );
    }).then(() => {
        console.log("Repacking...");
        return call(
            "npx",
            [
                "asar",
                "pack",
                `${resources}/app.asar.unpacked`,
                `${resources}/app.asar`,
            ],
        );
    });
}

/**
 * @param {string} cssFile custom css rules
 */
function constructPayload(cssFile="custom.css") {
    contents = fs.readFileSync(cssFile, "utf-8");
    return dedent(`
        /**
         * To enable developer mode (for quicker iterations), open slack from              
         * command line:                                                                   
         *      \`SLACK_DEVELOPER_MENU=true open /Applications/Slack.app\`
         *
         * Then, you can open it with \`cmd + alt + shift + i\`. 
         * 
         * This injects custom CSS into the mac app, so that we can have dark theming.  
         * Source: https://gist.github.com/DrewML/0acd2e389492e7d9d6be63386d75dd99
         */
        const customCSSString = \`
        ${contents}
        \`;

        function injectCSS() {
            const styleBlock = document.createElement("style");
            styleBlock.appendChild(document.createTextNode(customCSSString));
            document.getElementsByTagName("head")[0].appendChild(styleBlock);
        }

        document.addEventListener("DOMContentLoaded", injectCSS);

        /**
         * Allows F5 to reload.
         */
        document.addEventListener("keydown", function (e) {
            if (e.which === 116) {
                location.reload();
            }
        });
    `);
}

/**
 * @param {string} command
 * @param {array} args
 * @return {Promise}
 */
function call(command, args) {
    return new Promise((resolve, reject) => {
        const child = spawn(command, args);
        child.stdout.on("data", (data) => {
            resolve(`${data}`.replace(/\n$/, ""));
        });
        child.stderr.on("data", (data) => {
            reject(`${data}`.replace(/\n$/, ""));
        });
        child.on("exit", (code, signal) => {
            if (code !== 0) {
                reject();
            } else {
                resolve();
            }
        });
    });
}

main();
