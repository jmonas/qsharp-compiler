// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

'use strict';
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import { startTelemetry, EventNames, sendTelemetryEvent, reporter } from './telemetry';
import { DotnetInfo, requireDotNetSdk, findDotNetSdk } from './dotnet';
import { getPackageInfo } from './packageInfo';
import { installTemplates, createNewProject, registerCommand, openDocumentationHome, installOrUpdateIQSharp, submitJob, getJobResults, getJobDetails } from './commands';
import { LanguageServer } from './languageServer';
import {LocalSubmissionsProvider} from './localSubmissionsProvider';
import {registerUIExtensionVariables, createAzExtOutputChannel, UIExtensionVariables } from '@microsoft/vscode-azext-utils';
import { AzureCliCredential, InteractiveBrowserCredential,ChainedTokenCredential } from '@azure/identity';
import {getWorkspaceFromUser} from "./quickPickWorkspace";
import {workspaceInfo} from "./commands";

let credential:AzureCliCredential|InteractiveBrowserCredential;
let authSource: string;
let accountAuthStatusBarItem: vscode.StatusBarItem;
let workSpaceStatusBarItem: vscode.StatusBarItem;
let submitJobStatusBarItem: vscode.StatusBarItem;

/**
 * Returns the root folder for the current workspace.
 */
function findRootFolder() : string {
    // FIXME: handle multiple workspace folders here.
    let workspaceFolders = vscode.workspace.workspaceFolders;
    if (workspaceFolders) {
        return workspaceFolders[0].uri.fsPath;
    } else {
        return '';
    }
}

// required before any interaction with Azure
// try to authenticate though AzureCliCredential first. If fails, authenticate through InteractiveBrowserCredential
async function getCredential(context: vscode.ExtensionContext, changeAccount=false ){
    if (credential && !changeAccount){
        return credential;
    }
        await vscode.window.withProgress({
        location: vscode.ProgressLocation.Notification,
        title: "Authenticating...",
        }, async (progress, token2) => {
        let tempCredential:any;
    try{
        if (changeAccount){
            tempCredential = new InteractiveBrowserCredential();

        }
        else{
        tempCredential = new ChainedTokenCredential(new AzureCliCredential(), new InteractiveBrowserCredential());
        }
        await tempCredential.getToken("https://management.azure.com/.default");
        // only successful authentication through browser will have the field below
        if(tempCredential["_sources"][1]["msalFlow"]["account"]["username"]){
            authSource = "browser";
        }
        else{
            authSource = "Az CLI";
        }
    }
    catch{
        vscode.window.showErrorMessage("Unable to connect to authenticate.");
        accountAuthStatusBarItem.hide();
        return;
    }
    accountAuthStatusBarItem.tooltip = `Authenticated from ${authSource}`;
    accountAuthStatusBarItem.show();
    credential = tempCredential;
    });
    return;
}

// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export async function activate(context: vscode.ExtensionContext) {

    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    console.log('[qsharp-lsp] Activated!');
    process.env['VSCODE_LOG_LEVEL'] = 'trace';

    startTelemetry(context);


    let packageInfo = getPackageInfo(context);
    let dotNetSdkVersion = packageInfo === undefined ? undefined : packageInfo.requiredDotNetCoreSDK;


    // Get any .NET Core SDK version number to report in telemetry.
    var dotNetSdk : DotnetInfo | undefined;
    try {
        dotNetSdk = await findDotNetSdk();
    } catch {
        dotNetSdk = undefined;
    }



    sendTelemetryEvent(
        EventNames.activate,
        {
            'dotnetVersion': dotNetSdk !== undefined
                ? dotNetSdk.version
                : "<missing>"
        },
        {}
    );


    // creates treeview of locally submitted jobs in custom panel
    const localSubmissionsProvider = new LocalSubmissionsProvider(context);
    vscode.window.createTreeView("quantum-jobs",  {
        treeDataProvider: localSubmissionsProvider,
    });

    // need to call registerUIExtensionVariables to use openReadOnlyJson from
    // @microsoft/vscode-azext-utils package
    const AzExtOutputChannel = await createAzExtOutputChannel("trial", "quantum-devkit-vscode");
    const args: UIExtensionVariables = {context: context, outputChannel:AzExtOutputChannel};
    registerUIExtensionVariables(args);


    accountAuthStatusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 202);
    accountAuthStatusBarItem.command = "quantum.changeAzureAccount";
    context.subscriptions.push(accountAuthStatusBarItem);
    accountAuthStatusBarItem.text = `$(verified)`;

    if(authSource){
        accountAuthStatusBarItem.tooltip = `Azure Quantum Auth: ${authSource}`;
        accountAuthStatusBarItem.show();
    }

    submitJobStatusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 201);
    submitJobStatusBarItem.command = "quantum.submitJob";
    context.subscriptions.push(submitJobStatusBarItem);
    submitJobStatusBarItem.text = `$(run-above) Submit Job to Azure Quantum`;
    submitJobStatusBarItem.show();



    workSpaceStatusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 200);
    const workspaceInfo: workspaceInfo | undefined = context.workspaceState.get("workspaceInfo");
    workSpaceStatusBarItem.command = "quantum.changeWorkspace";
    context.subscriptions.push(workSpaceStatusBarItem);
    if (workspaceInfo && workspaceInfo["workspace"]){
        workSpaceStatusBarItem.text = `Azure Workspace: ${workspaceInfo["workspace"]}`;
        workSpaceStatusBarItem.show();
    }

    // Register commands that use the .NET Core SDK.
    // We do so as early as possible so that we can handle if someone calls
    // a command before we found the .NET Core SDK.
    registerCommand(
        context,
        "quantum.newProject",
        () => {
            createNewProject(context);
        }
    );

    registerCommand(
        context,
        "quantum.installTemplates",
        () => {
            requireDotNetSdk(dotNetSdkVersion).then(
                dotNetSdk => installTemplates(dotNetSdk, packageInfo)
            );
        }
    );

    registerCommand(
        context,
        "quantum.openDocumentation",
        openDocumentationHome
    );

    registerCommand(
        context,
        "quantum.installIQSharp",
        () => {
            requireDotNetSdk(dotNetSdkVersion).then(
                dotNetSdk => installOrUpdateIQSharp(
                    dotNetSdk,
                    packageInfo ? packageInfo.nugetVersion : undefined
                )
            );
        }
    );

    registerCommand(
        context,
        "quantum.submitJob",
        async() => {
            sendTelemetryEvent(EventNames.jobSubmissionStarted, {},{});
            await getCredential(context);
            requireDotNetSdk(dotNetSdkVersion).then(
                dotNetSdk => submitJob(context, dotNetSdk, localSubmissionsProvider, credential,workSpaceStatusBarItem )
            );
        }
    );

    registerCommand(
        context,
        "quantum.changeWorkspace",
        async() => {
            sendTelemetryEvent(EventNames.changeWorkspace, {},{});
            await getCredential(context);
            await getWorkspaceFromUser(context, credential, workSpaceStatusBarItem);
        }
    );

    registerCommand(
        context,
        "quantum.getJob",
        async() => {
            sendTelemetryEvent(EventNames.getJobResults, {"method": "command-palette"},{});
            await getCredential(context);
            getJobResults(context, credential,workSpaceStatusBarItem);
        }
    );


    vscode.commands.registerCommand('quantum-jobs.clearJobs', async () =>{
        const userQuery = await vscode.window.showWarningMessage("Are you sure you want to clear your jobs?", ...["Clear","Cancel"]);
        if(userQuery === "Clear"){
            context.workspaceState.update("locallySubmittedJobs", undefined);
            localSubmissionsProvider.refresh(context);
        }
        }
    );

    vscode.commands.registerCommand('quantum-jobs.jobDetails', async (job) =>{
        sendTelemetryEvent(EventNames.getJobDetails, {},{});
        await getCredential(context);
        const jobId = job['jobDetails']['jobId'];
        getJobDetails(context, credential, jobId, workSpaceStatusBarItem);
    });


    vscode.commands.registerCommand('quantum-jobs.jobResults', async (job) =>{
        await getCredential(context);
        const jobId = job['jobDetails']['jobId'];
        sendTelemetryEvent(
            EventNames.getJobResults,
            {
                'method': "results-button"
            },
        );
        getJobResults(context, credential,workSpaceStatusBarItem, jobId);
    }
    );
    vscode.commands.registerCommand('quantum.changeAzureAccount', async () =>{
        sendTelemetryEvent(EventNames.changeAzureAccount, {},{});
        await getCredential(context, true);
    });



    let rootFolder = findRootFolder();

    // Start the language server client.
    let languageServer = new LanguageServer(context, rootFolder);
    await languageServer
        .start()
        .catch(
            err => {
                console.log(`[qsharp-lsp] Language server failed to start: ${err}`);
                let reportFeedbackItem = "Report feedback...";
                vscode.window.showErrorMessage(
                    `Language server failed to start: ${err}`,
                    reportFeedbackItem
                ).then(
                    item => {
                        vscode.env.openExternal(vscode.Uri.parse(
                            "https://github.com/microsoft/qsharp-compiler/issues/new?assignees=&labels=bug,Area-IDE&template=bug_report.md&title="
                        ));
                    }
                );
            }
        );

        return context;

}

// this method is called when your extension is deactivated
export function deactivate() {
    if (reporter) { reporter.dispose(); }
}


