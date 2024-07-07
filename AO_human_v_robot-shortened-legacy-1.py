#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v2023.2.3),
    on March 31, 2024, at 09:40
If you publish work using this script the most relevant publication is:

    Peirce J, Gray JR, Simpson S, MacAskill M, Höchenberger R, Sogo H, Kastman E, Lindeløv JK. (2019) 
        PsychoPy2: Experiments in behavior made easy Behav Res 51: 195. 
        https://doi.org/10.3758/s13428-018-01193-y

"""

# --- Import packages ---
from psychopy import locale_setup
from psychopy import prefs
from psychopy import plugins
plugins.activatePlugins()
prefs.hardware['audioLib'] = 'ptb'
prefs.hardware['audioLatencyMode'] = '3'
from psychopy import sound, gui, visual, core, data, event, logging, clock, colors, layout
from psychopy.tools import environmenttools
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER, priority)

import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle, choice as randchoice
import os  # handy system and path functions
import sys  # to get file system encoding

import psychopy.iohub as io
from psychopy.hardware import keyboard
from psychopy.hardware import emotiv

# Run 'Before Experiment' code from codeSetup
from collections import Counter
# Run 'Before Experiment' code from codeFixation
import random
# --- Setup global variables (available in all functions) ---
# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
# Store info about the experiment session
psychopyVersion = '2023.2.3'
expName = 'AO_human_v_robot'  # from the Builder filename that created this script
expInfo = {
    'participant': f"{randint(0, 999999):06.0f}",
    'session': '001',
    'date': data.getDateStr(),  # add a simple timestamp
    'expName': expName,
    'psychopyVersion': psychopyVersion,
}


def showExpInfoDlg(expInfo):
    """
    Show participant info dialog.
    Parameters
    ==========
    expInfo : dict
        Information about this experiment, created by the `setupExpInfo` function.
    
    Returns
    ==========
    dict
        Information about this experiment.
    """
    # temporarily remove keys which the dialog doesn't need to show
    poppedKeys = {
        'date': expInfo.pop('date', data.getDateStr()),
        'expName': expInfo.pop('expName', expName),
        'psychopyVersion': expInfo.pop('psychopyVersion', psychopyVersion),
    }
    # show participant info dialog
    dlg = gui.DlgFromDict(dictionary=expInfo, sortKeys=False, title=expName)
    if dlg.OK == False:
        core.quit()  # user pressed cancel
    # restore hidden keys
    expInfo.update(poppedKeys)
    # return expInfo
    return expInfo


def setupData(expInfo, dataDir=None):
    """
    Make an ExperimentHandler to handle trials and saving.
    
    Parameters
    ==========
    expInfo : dict
        Information about this experiment, created by the `setupExpInfo` function.
    dataDir : Path, str or None
        Folder to save the data to, leave as None to create a folder in the current directory.    
    Returns
    ==========
    psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about 
        where to save it to.
    """
    
    # data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
    if dataDir is None:
        dataDir = _thisDir
    filename = u'data/%s_%s_%s' % (expInfo['participant'], expName, expInfo['date'])
    # make sure filename is relative to dataDir
    if os.path.isabs(filename):
        dataDir = os.path.commonprefix([dataDir, filename])
        filename = os.path.relpath(filename, dataDir)
    
    # an ExperimentHandler isn't essential but helps with data saving
    thisExp = data.ExperimentHandler(
        name=expName, version='',
        extraInfo=expInfo, runtimeInfo=None,
        originPath='C:\\Users\\anhtn\\OneDrive - PennO365\\Documents\\GitHub\\AO_human_v_robot_main\\AO_human_v_robot-shortened.py',
        savePickle=True, saveWideText=True,
        dataFileName=dataDir + os.sep + filename, sortColumns='time'
    )
    thisExp.setPriority('thisRow.t', priority.CRITICAL)
    thisExp.setPriority('expName', priority.LOW)
    # return experiment handler
    return thisExp


def setupLogging(filename):
    """
    Setup a log file and tell it what level to log at.
    
    Parameters
    ==========
    filename : str or pathlib.Path
        Filename to save log file and data files as, doesn't need an extension.
    
    Returns
    ==========
    psychopy.logging.LogFile
        Text stream to receive inputs from the logging system.
    """
    # this outputs to the screen, not a file
    logging.console.setLevel(logging.EXP)
    # save a log file for detail verbose info
    logFile = logging.LogFile(filename+'.log', level=logging.EXP)
    
    return logFile


def setupWindow(expInfo=None, win=None):
    """
    Setup the Window
    
    Parameters
    ==========
    expInfo : dict
        Information about this experiment, created by the `setupExpInfo` function.
    win : psychopy.visual.Window
        Window to setup - leave as None to create a new window.
    
    Returns
    ==========
    psychopy.visual.Window
        Window in which to run this experiment.
    """
    if win is None:
        # if not given a window to setup, make one
        win = visual.Window(
            size=[1920, 1200], fullscr=True, screen=2,
            winType='pyglet', allowStencil=False,
            monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
            backgroundImage='', backgroundFit='none',
            blendMode='avg', useFBO=True,
            units='height'
        )
        if expInfo is not None:
            # store frame rate of monitor if we can measure it
            expInfo['frameRate'] = win.getActualFrameRate()
    else:
        # if we have a window, just set the attributes which are safe to set
        win.color = [0,0,0]
        win.colorSpace = 'rgb'
        win.backgroundImage = ''
        win.backgroundFit = 'none'
        win.units = 'height'
    win.mouseVisible = True
    win.hideMessage()
    return win


def setupInputs(expInfo, thisExp, win):
    """
    Setup whatever inputs are available (mouse, keyboard, eyetracker, etc.)
    
    Parameters
    ==========
    expInfo : dict
        Information about this experiment, created by the `setupExpInfo` function.
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about 
        where to save it to.
    win : psychopy.visual.Window
        Window in which to run this experiment.
    Returns
    ==========
    dict
        Dictionary of input devices by name.
    """
    # --- Setup input devices ---
    inputs = {}
    ioConfig = {}
    
    # Setup iohub keyboard
    ioConfig['Keyboard'] = dict(use_keymap='psychopy')
    
    ioSession = '1'
    if 'session' in expInfo:
        ioSession = str(expInfo['session'])
    ioServer = io.launchHubServer(window=win, **ioConfig)
    eyetracker = None
    
    # create a default keyboard (e.g. to check for escape)
    defaultKeyboard = keyboard.Keyboard(backend='iohub')
    # return inputs dict
    return {
        'ioServer': ioServer,
        'defaultKeyboard': defaultKeyboard,
        'eyetracker': eyetracker,
    }

def pauseExperiment(thisExp, inputs=None, win=None, timers=[], playbackComponents=[]):
    """
    Pause this experiment, preventing the flow from advancing to the next routine until resumed.
    
    Parameters
    ==========
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about 
        where to save it to.
    inputs : dict
        Dictionary of input devices by name.
    win : psychopy.visual.Window
        Window for this experiment.
    timers : list, tuple
        List of timers to reset once pausing is finished.
    playbackComponents : list, tuple
        List of any components with a `pause` method which need to be paused.
    """
    # if we are not paused, do nothing
    if thisExp.status != PAUSED:
        return
    
    # pause any playback components
    for comp in playbackComponents:
        comp.pause()
    # prevent components from auto-drawing
    win.stashAutoDraw()
    # run a while loop while we wait to unpause
    while thisExp.status == PAUSED:
        # make sure we have a keyboard
        if inputs is None:
            inputs = {
                'defaultKeyboard': keyboard.Keyboard(backend='ioHub')
            }
        # check for quit (typically the Esc key)
        if inputs['defaultKeyboard'].getKeys(keyList=['escape']):
            endExperiment(thisExp, win=win, inputs=inputs)
        # flip the screen
        win.flip()
    # if stop was requested while paused, quit
    if thisExp.status == FINISHED:
        endExperiment(thisExp, inputs=inputs, win=win)
    # resume any playback components
    for comp in playbackComponents:
        comp.play()
    # restore auto-drawn components
    win.retrieveAutoDraw()
    # reset any timers
    for timer in timers:
        timer.reset()


def run(expInfo, thisExp, win, inputs, globalClock=None, thisSession=None):
    """
    Run the experiment flow.
    
    Parameters
    ==========
    expInfo : dict
        Information about this experiment, created by the `setupExpInfo` function.
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about 
        where to save it to.
    psychopy.visual.Window
        Window in which to run this experiment.
    inputs : dict
        Dictionary of input devices by name.
    globalClock : psychopy.core.clock.Clock or None
        Clock to get global time from - supply None to make a new one.
    thisSession : psychopy.session.Session or None
        Handle of the Session object this experiment is being run from, if any.
    """
    # mark experiment as started
    thisExp.status = STARTED
    # make sure variables created by exec are available globally
    exec = environmenttools.setExecEnvironment(globals())
    # get device handles from dict of input devices
    ioServer = inputs['ioServer']
    defaultKeyboard = inputs['defaultKeyboard']
    eyetracker = inputs['eyetracker']
    # make sure we're running in the directory for this experiment
    os.chdir(_thisDir)
    # get filename from ExperimentHandler for convenience
    filename = thisExp.dataFileName
    frameTolerance = 0.001  # how close to onset before 'same' frame
    endExpNow = False  # flag for 'escape' or other condition => quit the exp
    # get frame duration from frame rate in expInfo
    if 'frameRate' in expInfo and expInfo['frameRate'] is not None:
        frameDur = 1.0 / round(expInfo['frameRate'])
    else:
        frameDur = 1.0 / 60.0  # could not measure, so guess
    
    # Start Code - component code to be run after the window creation
    # This is generated by the writeStartCode
    # This is generated by the writeStartCode
    # This is generated by the writeStartCode
    # This is generated by the writeStartCode
    
    # --- Initialize components for Routine "stimLoader" ---
    # Run 'Begin Experiment' code from codeLoader
    blockList = [];
    conditionList = [];
    stimList = [];
    stimDirList=[];
    catchtrialObjList = [];
    markerValList = [];
    
    N_block = 8
    
    
    # --- Initialize components for Routine "welcomeScreen" ---
    # Run 'Begin Experiment' code from codeSetup
    #blockLenList = []
    
    
    textWelcome = visual.TextStim(win=win, name='textWelcome',
        text='Welcome!\n\nPress Space to start the experiment',
        font='Open Sans',
        pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-1.0);
    keyWelcome = keyboard.Keyboard()
    cortex_rec = visual.BaseVisualStim(win=win, name="cortex_rec")
    cortex_obj = emotiv.Cortex(subject=expInfo['participant'])
    
    # --- Initialize components for Routine "blockSetup" ---
    # Run 'Begin Experiment' code from codeBlockSetup
    counterBlock = 0
    
    # --- Initialize components for Routine "breakPeriod" ---
    # Run 'Begin Experiment' code from codeBreakCD
    progVal = 0
    
    breakLength = 15 + 1
    breakCD = breakLength
    textBreak = visual.TextStim(win=win, name='textBreak',
        text="Let's have 15-second break.\n\nAfter this break, focus on the white cross at the center.",
        font='Open Sans',
        pos=(0, 0.25), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-1.0);
    textBreakCD = visual.TextStim(win=win, name='textBreakCD',
        text='',
        font='Open Sans',
        pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-2.0);
    prog = visual.Progress(
        win, name='prog',
        progress=0.0,
        pos=(-0.3, -0.25), size=(0.6, 0.1), anchor='center left', units='height',
        barColor='white', backColor=None, borderColor='white', colorSpace='rgb',
        lineWidth=4.0, opacity=1.0, ori=0.0,
        depth=-3
    )
    textProg = visual.TextStim(win=win, name='textProg',
        text='Your progress',
        font='Open Sans',
        pos=(0, -0.35), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-4.0);
    skipBreak = keyboard.Keyboard()
    
    # --- Initialize components for Routine "interTrialInterval" ---
    skipITI = keyboard.Keyboard()
    # This is generated by writeInitCode
    ITImarker = visual.BaseVisualStim(win=win, name="ITImarker")
    
    # --- Initialize components for Routine "fixationCross" ---
    crossFixation = visual.ShapeStim(
        win=win, name='crossFixation', vertices='cross',
        size=(0.1, 0.1),
        ori=0.0, pos=(0, 0), anchor='center',
        lineWidth=1.0,     colorSpace='rgb',  lineColor='white', fillColor='white',
        opacity=None, depth=-1.0, interpolate=True)
    # This is generated by writeInitCode
    fixationCrossMarker = visual.BaseVisualStim(win=win, name="fixationCrossMarker")
    
    # --- Initialize components for Routine "stimVid" ---
    # Run 'Begin Experiment' code from codeStim
    counterStim = 0
    stimMovie = visual.MovieStim(
        win, name='stimMovie',
        filename=None, movieLib='ffpyplayer',
        loop=False, volume=1.0, noAudio=True,
        pos=(0, 0), size=(1.77, 1), units=win.units,
        ori=0.0, anchor='center',opacity=None, contrast=1.0,
        depth=-1
    )
    skipStim = keyboard.Keyboard()
    # This is generated by writeInitCode
    stimMarker = visual.BaseVisualStim(win=win, name="stimMarker")
    
    # --- Initialize components for Routine "catchtrialQues" ---
    textQues = visual.TextStim(win=win, name='textQues',
        text='In the previous clip, \n\nwhich object \n\ndoes the actor use?',
        font='Open Sans',
        pos=(0, .25), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-1.0);
    textAnsAffirm = visual.TextStim(win=win, name='textAnsAffirm',
        text='',
        font='Open Sans',
        pos=[0,0], height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-2.0);
    textAnsNeg = visual.TextStim(win=win, name='textAnsNeg',
        text='',
        font='Open Sans',
        pos=[0,0], height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-3.0);
    keyRespAffirm = keyboard.Keyboard()
    keyRespNeg = keyboard.Keyboard()
    textNoAnswer = visual.TextStim(win=win, name='textNoAnswer',
        text="I don't know",
        font='Open Sans',
        pos=(0, -0.3), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-6.0);
    keyRespNoAnswer = keyboard.Keyboard()
    
    # --- Initialize components for Routine "markCTanswer" ---
    # Run 'Begin Experiment' code from codeGetAnswer
    answerCTVal = 0
    # This is generated by writeInitCode
    CTmarker = visual.BaseVisualStim(win=win, name="CTmarker")
    
    # --- Initialize components for Routine "postStimInterval" ---
    
    # --- Initialize components for Routine "endBlock" ---
    
    # --- Initialize components for Routine "endExperiment" ---
    textEnd = visual.TextStim(win=win, name='textEnd',
        text='This is the end of the experiment.\n\nThank you for your effort and attention!\n\nPress Space to quit.',
        font='Open Sans',
        pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=0.0);
    keyQuit = keyboard.Keyboard()
    
    # create some handy timers
    if globalClock is None:
        globalClock = core.Clock()  # to track the time since experiment started
    if ioServer is not None:
        ioServer.syncClock(globalClock)
    logging.setDefaultClock(globalClock)
    routineTimer = core.Clock()  # to track time remaining of each (possibly non-slip) routine
    win.flip()  # flip window to reset last flip timer
    # store the exact time the global clock started
    expInfo['expStart'] = data.getDateStr(format='%Y-%m-%d %Hh%M.%S.%f %z', fractionalSecondDigits=6)
    
    # set up handler to look after randomisation of conditions etc
    loopLoader = data.TrialHandler(nReps=1.0, method='sequential', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions('trial_files/AO_final_randomized_trials.xlsx'),
        seed=None, name='loopLoader')
    thisExp.addLoop(loopLoader)  # add the loop to the experiment
    thisLoopLoader = loopLoader.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisLoopLoader.rgb)
    if thisLoopLoader != None:
        for paramName in thisLoopLoader:
            globals()[paramName] = thisLoopLoader[paramName]
    
    for thisLoopLoader in loopLoader:
        currentLoop = loopLoader
        thisExp.timestampOnFlip(win, 'thisRow.t')
        # pause experiment here if requested
        if thisExp.status == PAUSED:
            pauseExperiment(
                thisExp=thisExp, 
                inputs=inputs, 
                win=win, 
                timers=[routineTimer], 
                playbackComponents=[]
        )
        # abbreviate parameter names if possible (e.g. rgb = thisLoopLoader.rgb)
        if thisLoopLoader != None:
            for paramName in thisLoopLoader:
                globals()[paramName] = thisLoopLoader[paramName]
        
        # --- Prepare to start Routine "stimLoader" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('stimLoader.started', globalClock.getTime())
        # Run 'Begin Routine' code from codeLoader
        blockList.append(blockNumber);
        stimList.append(stimulus);
        conditionList.append(condition);
        stimDirList.append(stimDir);
        
        catchtrialObjList.append(catchtrialObj);
        markerValList.append(markerVal);
        # keep track of which components have finished
        stimLoaderComponents = []
        for thisComponent in stimLoaderComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "stimLoader" ---
        routineForceEnded = not continueRoutine
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, inputs=inputs, win=win)
                return
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in stimLoaderComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "stimLoader" ---
        for thisComponent in stimLoaderComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('stimLoader.stopped', globalClock.getTime())
        # the Routine "stimLoader" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        thisExp.nextEntry()
        
        if thisSession is not None:
            # if running in a Session with a Liaison client, send data up to now
            thisSession.sendExperimentData()
    # completed 1.0 repeats of 'loopLoader'
    
    
    # --- Prepare to start Routine "welcomeScreen" ---
    continueRoutine = True
    # update component parameters for each repeat
    thisExp.addData('welcomeScreen.started', globalClock.getTime())
    # Run 'Begin Routine' code from codeSetup
    counts = Counter(blockList)
    
    countBlockList = [counts[i] for i in range(N_block)] # count the number of trials within each block
    print('=*'*50)
    print(countBlockList)
    
    #print(catchtrialObjList)
    keyWelcome.keys = []
    keyWelcome.rt = []
    _keyWelcome_allKeys = []
    # keep track of which components have finished
    welcomeScreenComponents = [textWelcome, keyWelcome, cortex_rec]
    for thisComponent in welcomeScreenComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1
    
    # --- Run Routine "welcomeScreen" ---
    routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *textWelcome* updates
        
        # if textWelcome is starting this frame...
        if textWelcome.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            textWelcome.frameNStart = frameN  # exact frame index
            textWelcome.tStart = t  # local t and not account for scr refresh
            textWelcome.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(textWelcome, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'textWelcome.started')
            # update status
            textWelcome.status = STARTED
            textWelcome.setAutoDraw(True)
        
        # if textWelcome is active this frame...
        if textWelcome.status == STARTED:
            # update params
            pass
        
        # *keyWelcome* updates
        waitOnFlip = False
        
        # if keyWelcome is starting this frame...
        if keyWelcome.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            keyWelcome.frameNStart = frameN  # exact frame index
            keyWelcome.tStart = t  # local t and not account for scr refresh
            keyWelcome.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(keyWelcome, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'keyWelcome.started')
            # update status
            keyWelcome.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(keyWelcome.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(keyWelcome.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if keyWelcome.status == STARTED and not waitOnFlip:
            theseKeys = keyWelcome.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _keyWelcome_allKeys.extend(theseKeys)
            if len(_keyWelcome_allKeys):
                keyWelcome.keys = _keyWelcome_allKeys[-1].name  # just the last key pressed
                keyWelcome.rt = _keyWelcome_allKeys[-1].rt
                keyWelcome.duration = _keyWelcome_allKeys[-1].duration
                # a response ends the routine
                continueRoutine = False
        
        # check for quit (typically the Esc key)
        if defaultKeyboard.getKeys(keyList=["escape"]):
            thisExp.status = FINISHED
        if thisExp.status == FINISHED or endExpNow:
            endExperiment(thisExp, inputs=inputs, win=win)
            return
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in welcomeScreenComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "welcomeScreen" ---
    for thisComponent in welcomeScreenComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    thisExp.addData('welcomeScreen.stopped', globalClock.getTime())
    # check responses
    if keyWelcome.keys in ['', [], None]:  # No response was made
        keyWelcome.keys = None
    thisExp.addData('keyWelcome.keys',keyWelcome.keys)
    if keyWelcome.keys != None:  # we had a response
        thisExp.addData('keyWelcome.rt', keyWelcome.rt)
        thisExp.addData('keyWelcome.duration', keyWelcome.duration)
    thisExp.nextEntry()
    # the Routine "welcomeScreen" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # set up handler to look after randomisation of conditions etc
    loopBlock = data.TrialHandler(nReps=N_block, method='sequential', 
        extraInfo=expInfo, originPath=-1,
        trialList=[None],
        seed=None, name='loopBlock')
    thisExp.addLoop(loopBlock)  # add the loop to the experiment
    thisLoopBlock = loopBlock.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisLoopBlock.rgb)
    if thisLoopBlock != None:
        for paramName in thisLoopBlock:
            globals()[paramName] = thisLoopBlock[paramName]
    
    for thisLoopBlock in loopBlock:
        currentLoop = loopBlock
        thisExp.timestampOnFlip(win, 'thisRow.t')
        # pause experiment here if requested
        if thisExp.status == PAUSED:
            pauseExperiment(
                thisExp=thisExp, 
                inputs=inputs, 
                win=win, 
                timers=[routineTimer], 
                playbackComponents=[]
        )
        # abbreviate parameter names if possible (e.g. rgb = thisLoopBlock.rgb)
        if thisLoopBlock != None:
            for paramName in thisLoopBlock:
                globals()[paramName] = thisLoopBlock[paramName]
        
        # --- Prepare to start Routine "blockSetup" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('blockSetup.started', globalClock.getTime())
        # Run 'Begin Routine' code from codeBlockSetup
        N_trial = countBlockList[counterBlock]
        print('=*'*50)
        print("Block: ", counterBlock)
        print('Number of trials: ', N_trial)
        if counterBlock == int(N_block/2):
            breakLength = 300 + 1
        else:
            breakLength = 15 + 1

        breakCD = breakLength
        
        # keep track of which components have finished
        blockSetupComponents = []
        for thisComponent in blockSetupComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "blockSetup" ---
        routineForceEnded = not continueRoutine
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, inputs=inputs, win=win)
                return
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in blockSetupComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "blockSetup" ---
        for thisComponent in blockSetupComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('blockSetup.stopped', globalClock.getTime())
        # the Routine "blockSetup" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        
        # set up handler to look after randomisation of conditions etc
        loopBreakCD = data.TrialHandler(nReps=breakLength, method='sequential', 
            extraInfo=expInfo, originPath=-1,
            trialList=[None],
            seed=None, name='loopBreakCD')
        thisExp.addLoop(loopBreakCD)  # add the loop to the experiment
        thisLoopBreakCD = loopBreakCD.trialList[0]  # so we can initialise stimuli with some values
        # abbreviate parameter names if possible (e.g. rgb = thisLoopBreakCD.rgb)
        if thisLoopBreakCD != None:
            for paramName in thisLoopBreakCD:
                globals()[paramName] = thisLoopBreakCD[paramName]
        
        for thisLoopBreakCD in loopBreakCD:
            currentLoop = loopBreakCD
            thisExp.timestampOnFlip(win, 'thisRow.t')
            # pause experiment here if requested
            if thisExp.status == PAUSED:
                pauseExperiment(
                    thisExp=thisExp, 
                    inputs=inputs, 
                    win=win, 
                    timers=[routineTimer], 
                    playbackComponents=[]
            )
            # abbreviate parameter names if possible (e.g. rgb = thisLoopBreakCD.rgb)
            if thisLoopBreakCD != None:
                for paramName in thisLoopBreakCD:
                    globals()[paramName] = thisLoopBreakCD[paramName]
            
            # --- Prepare to start Routine "breakPeriod" ---
            continueRoutine = True
            # update component parameters for each repeat
            thisExp.addData('breakPeriod.started', globalClock.getTime())
            # Run 'Begin Routine' code from codeBreakCD
            progVal = counterBlock / N_block
            
            breakCD = breakCD -1
            textBreakCD.setText(breakCD)
            prog.setProgress(progVal)
            skipBreak.keys = []
            skipBreak.rt = []
            _skipBreak_allKeys = []
            # keep track of which components have finished
            breakPeriodComponents = [textBreak, textBreakCD, prog, textProg, skipBreak]
            for thisComponent in breakPeriodComponents:
                thisComponent.tStart = None
                thisComponent.tStop = None
                thisComponent.tStartRefresh = None
                thisComponent.tStopRefresh = None
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            # reset timers
            t = 0
            _timeToFirstFrame = win.getFutureFlipTime(clock="now")
            frameN = -1
            
            # --- Run Routine "breakPeriod" ---
            routineForceEnded = not continueRoutine
            while continueRoutine and routineTimer.getTime() < 1.0:
                # get current time
                t = routineTimer.getTime()
                tThisFlip = win.getFutureFlipTime(clock=routineTimer)
                tThisFlipGlobal = win.getFutureFlipTime(clock=None)
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *textBreak* updates
                
                # if textBreak is starting this frame...
                if textBreak.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    textBreak.frameNStart = frameN  # exact frame index
                    textBreak.tStart = t  # local t and not account for scr refresh
                    textBreak.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(textBreak, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'textBreak.started')
                    # update status
                    textBreak.status = STARTED
                    textBreak.setAutoDraw(True)
                
                # if textBreak is active this frame...
                if textBreak.status == STARTED:
                    # update params
                    pass
                
                # if textBreak is stopping this frame...
                if textBreak.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > textBreak.tStartRefresh + 1.0-frameTolerance:
                        # keep track of stop time/frame for later
                        textBreak.tStop = t  # not accounting for scr refresh
                        textBreak.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'textBreak.stopped')
                        # update status
                        textBreak.status = FINISHED
                        textBreak.setAutoDraw(False)
                
                # *textBreakCD* updates
                
                # if textBreakCD is starting this frame...
                if textBreakCD.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    textBreakCD.frameNStart = frameN  # exact frame index
                    textBreakCD.tStart = t  # local t and not account for scr refresh
                    textBreakCD.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(textBreakCD, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'textBreakCD.started')
                    # update status
                    textBreakCD.status = STARTED
                    textBreakCD.setAutoDraw(True)
                
                # if textBreakCD is active this frame...
                if textBreakCD.status == STARTED:
                    # update params
                    pass
                
                # if textBreakCD is stopping this frame...
                if textBreakCD.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > textBreakCD.tStartRefresh + 1.0-frameTolerance:
                        # keep track of stop time/frame for later
                        textBreakCD.tStop = t  # not accounting for scr refresh
                        textBreakCD.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'textBreakCD.stopped')
                        # update status
                        textBreakCD.status = FINISHED
                        textBreakCD.setAutoDraw(False)
                
                # *prog* updates
                
                # if prog is starting this frame...
                if prog.status == NOT_STARTED and tThisFlip >= 0-frameTolerance:
                    # keep track of start time/frame for later
                    prog.frameNStart = frameN  # exact frame index
                    prog.tStart = t  # local t and not account for scr refresh
                    prog.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(prog, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'prog.started')
                    # update status
                    prog.status = STARTED
                    prog.setAutoDraw(True)
                
                # if prog is active this frame...
                if prog.status == STARTED:
                    # update params
                    pass
                
                # if prog is stopping this frame...
                if prog.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > prog.tStartRefresh + 1-frameTolerance:
                        # keep track of stop time/frame for later
                        prog.tStop = t  # not accounting for scr refresh
                        prog.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'prog.stopped')
                        # update status
                        prog.status = FINISHED
                        prog.setAutoDraw(False)
                
                # *textProg* updates
                
                # if textProg is starting this frame...
                if textProg.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    textProg.frameNStart = frameN  # exact frame index
                    textProg.tStart = t  # local t and not account for scr refresh
                    textProg.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(textProg, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'textProg.started')
                    # update status
                    textProg.status = STARTED
                    textProg.setAutoDraw(True)
                
                # if textProg is active this frame...
                if textProg.status == STARTED:
                    # update params
                    pass
                
                # if textProg is stopping this frame...
                if textProg.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > textProg.tStartRefresh + 1.0-frameTolerance:
                        # keep track of stop time/frame for later
                        textProg.tStop = t  # not accounting for scr refresh
                        textProg.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'textProg.stopped')
                        # update status
                        textProg.status = FINISHED
                        textProg.setAutoDraw(False)
                
                # *skipBreak* updates
                waitOnFlip = False
                
                # if skipBreak is starting this frame...
                if skipBreak.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    skipBreak.frameNStart = frameN  # exact frame index
                    skipBreak.tStart = t  # local t and not account for scr refresh
                    skipBreak.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(skipBreak, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'skipBreak.started')
                    # update status
                    skipBreak.status = STARTED
                    # keyboard checking is just starting
                    waitOnFlip = True
                    win.callOnFlip(skipBreak.clock.reset)  # t=0 on next screen flip
                    win.callOnFlip(skipBreak.clearEvents, eventType='keyboard')  # clear events on next screen flip
                
                # if skipBreak is stopping this frame...
                if skipBreak.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > skipBreak.tStartRefresh + 1-frameTolerance:
                        # keep track of stop time/frame for later
                        skipBreak.tStop = t  # not accounting for scr refresh
                        skipBreak.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'skipBreak.stopped')
                        # update status
                        skipBreak.status = FINISHED
                        skipBreak.status = FINISHED
                if skipBreak.status == STARTED and not waitOnFlip:
                    theseKeys = skipBreak.getKeys(keyList=['s'], ignoreKeys=["escape"], waitRelease=False)
                    _skipBreak_allKeys.extend(theseKeys)
                    if len(_skipBreak_allKeys):
                        skipBreak.keys = _skipBreak_allKeys[-1].name  # just the last key pressed
                        skipBreak.rt = _skipBreak_allKeys[-1].rt
                        skipBreak.duration = _skipBreak_allKeys[-1].duration
                        # a response ends the routine
                        continueRoutine = False
                
                # check for quit (typically the Esc key)
                if defaultKeyboard.getKeys(keyList=["escape"]):
                    thisExp.status = FINISHED
                if thisExp.status == FINISHED or endExpNow:
                    endExperiment(thisExp, inputs=inputs, win=win)
                    return
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    routineForceEnded = True
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in breakPeriodComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # --- Ending Routine "breakPeriod" ---
            for thisComponent in breakPeriodComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            thisExp.addData('breakPeriod.stopped', globalClock.getTime())
            # check responses
            if skipBreak.keys in ['', [], None]:  # No response was made
                skipBreak.keys = None
            loopBreakCD.addData('skipBreak.keys',skipBreak.keys)
            if skipBreak.keys != None:  # we had a response
                loopBreakCD.addData('skipBreak.rt', skipBreak.rt)
                loopBreakCD.addData('skipBreak.duration', skipBreak.duration)
            # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
            if routineForceEnded:
                routineTimer.reset()
            else:
                routineTimer.addTime(-1.000000)
            thisExp.nextEntry()
            
            if thisSession is not None:
                # if running in a Session with a Liaison client, send data up to now
                thisSession.sendExperimentData()
        # completed breakLength repeats of 'loopBreakCD'
        
        
        # set up handler to look after randomisation of conditions etc
        loopTrial = data.TrialHandler(nReps=N_trial, method='sequential', 
            extraInfo=expInfo, originPath=-1,
            trialList=[None],
            seed=None, name='loopTrial')
        thisExp.addLoop(loopTrial)  # add the loop to the experiment
        thisLoopTrial = loopTrial.trialList[0]  # so we can initialise stimuli with some values
        # abbreviate parameter names if possible (e.g. rgb = thisLoopTrial.rgb)
        if thisLoopTrial != None:
            for paramName in thisLoopTrial:
                globals()[paramName] = thisLoopTrial[paramName]
        
        for thisLoopTrial in loopTrial:
            currentLoop = loopTrial
            thisExp.timestampOnFlip(win, 'thisRow.t')
            # pause experiment here if requested
            if thisExp.status == PAUSED:
                pauseExperiment(
                    thisExp=thisExp, 
                    inputs=inputs, 
                    win=win, 
                    timers=[routineTimer], 
                    playbackComponents=[]
            )
            # abbreviate parameter names if possible (e.g. rgb = thisLoopTrial.rgb)
            if thisLoopTrial != None:
                for paramName in thisLoopTrial:
                    globals()[paramName] = thisLoopTrial[paramName]
            
            # --- Prepare to start Routine "interTrialInterval" ---
            continueRoutine = True
            # update component parameters for each repeat
            thisExp.addData('interTrialInterval.started', globalClock.getTime())
            # Run 'Begin Routine' code from codeITI
            itiLen = round(random.uniform(3.5, 4), 3)
            itiVal = 3000
            print('-*'*100)
            print('itiVal: ', itiVal)
            
            skipITI.keys = []
            skipITI.rt = []
            _skipITI_allKeys = []
            # This is generated by the writeRoutineStartCode
            # keep track of which components have finished
            interTrialIntervalComponents = [skipITI, ITImarker]
            for thisComponent in interTrialIntervalComponents:
                thisComponent.tStart = None
                thisComponent.tStop = None
                thisComponent.tStartRefresh = None
                thisComponent.tStopRefresh = None
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            # reset timers
            t = 0
            _timeToFirstFrame = win.getFutureFlipTime(clock="now")
            frameN = -1
            
            # --- Run Routine "interTrialInterval" ---
            routineForceEnded = not continueRoutine
            while continueRoutine:
                # get current time
                t = routineTimer.getTime()
                tThisFlip = win.getFutureFlipTime(clock=routineTimer)
                tThisFlipGlobal = win.getFutureFlipTime(clock=None)
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *skipITI* updates
                waitOnFlip = False
                
                # if skipITI is starting this frame...
                if skipITI.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    skipITI.frameNStart = frameN  # exact frame index
                    skipITI.tStart = t  # local t and not account for scr refresh
                    skipITI.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(skipITI, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'skipITI.started')
                    # update status
                    skipITI.status = STARTED
                    # keyboard checking is just starting
                    waitOnFlip = True
                    win.callOnFlip(skipITI.clock.reset)  # t=0 on next screen flip
                    win.callOnFlip(skipITI.clearEvents, eventType='keyboard')  # clear events on next screen flip
                
                # if skipITI is stopping this frame...
                if skipITI.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > skipITI.tStartRefresh + itiLen-frameTolerance:
                        # keep track of stop time/frame for later
                        skipITI.tStop = t  # not accounting for scr refresh
                        skipITI.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'skipITI.stopped')
                        # update status
                        skipITI.status = FINISHED
                        skipITI.status = FINISHED
                if skipITI.status == STARTED and not waitOnFlip:
                    theseKeys = skipITI.getKeys(keyList=['s'], ignoreKeys=["escape"], waitRelease=False)
                    _skipITI_allKeys.extend(theseKeys)
                    if len(_skipITI_allKeys):
                        skipITI.keys = _skipITI_allKeys[-1].name  # just the last key pressed
                        skipITI.rt = _skipITI_allKeys[-1].rt
                        skipITI.duration = _skipITI_allKeys[-1].duration
                        # a response ends the routine
                        continueRoutine = False
                
                # if ITImarker is starting this frame...
                if ITImarker.status == NOT_STARTED and t >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    ITImarker.frameNStart = frameN  # exact frame index
                    ITImarker.tStart = t  # local t and not account for scr refresh
                    ITImarker.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(ITImarker, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.addData('ITImarker.started', t)
                    # update status
                    ITImarker.status = STARTED
                    ITImarker.status = STARTED
                    delta_time = tThisFlip-t  # Adding the extra time between now and the next screen flip
                    cortex_obj.inject_marker(value=str(itiVal), label='intertrial_interval', delta_time=delta_time)
                    ITImarker.start_sent = True
                
                # if ITImarker is stopping this frame...
                if ITImarker.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > ITImarker.tStartRefresh + itiLen-frameTolerance:
                        # keep track of stop time/frame for later
                        ITImarker.tStop = t  # not accounting for scr refresh
                        ITImarker.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.addData('ITImarker.stopped', t)
                        # update status
                        ITImarker.status = FINISHED
                        ITImarker.status = FINISHED
                
                # check for quit (typically the Esc key)
                if defaultKeyboard.getKeys(keyList=["escape"]):
                    thisExp.status = FINISHED
                if thisExp.status == FINISHED or endExpNow:
                    endExperiment(thisExp, inputs=inputs, win=win)
                    return
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    routineForceEnded = True
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in interTrialIntervalComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # --- Ending Routine "interTrialInterval" ---
            for thisComponent in interTrialIntervalComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            thisExp.addData('interTrialInterval.stopped', globalClock.getTime())
            # check responses
            if skipITI.keys in ['', [], None]:  # No response was made
                skipITI.keys = None
            loopTrial.addData('skipITI.keys',skipITI.keys)
            if skipITI.keys != None:  # we had a response
                loopTrial.addData('skipITI.rt', skipITI.rt)
                loopTrial.addData('skipITI.duration', skipITI.duration)
            # This is generated by the writeRoutineEndCode
            # the Routine "interTrialInterval" was not non-slip safe, so reset the non-slip timer
            routineTimer.reset()
            
            # --- Prepare to start Routine "fixationCross" ---
            continueRoutine = True
            # update component parameters for each repeat
            thisExp.addData('fixationCross.started', globalClock.getTime())
            # Run 'Begin Routine' code from codeFixation
            #fixationLen = round(random.uniform(0.5, 0.75),3) 
            #fixationLen = 0.75
            fixationLen = 1
            fixationVal = 1000
            print('fixationVal: ', fixationVal)
            # This is generated by the writeRoutineStartCode
            # keep track of which components have finished
            fixationCrossComponents = [crossFixation, fixationCrossMarker]
            for thisComponent in fixationCrossComponents:
                thisComponent.tStart = None
                thisComponent.tStop = None
                thisComponent.tStartRefresh = None
                thisComponent.tStopRefresh = None
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            # reset timers
            t = 0
            _timeToFirstFrame = win.getFutureFlipTime(clock="now")
            frameN = -1
            
            # --- Run Routine "fixationCross" ---
            routineForceEnded = not continueRoutine
            while continueRoutine:
                # get current time
                t = routineTimer.getTime()
                tThisFlip = win.getFutureFlipTime(clock=routineTimer)
                tThisFlipGlobal = win.getFutureFlipTime(clock=None)
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *crossFixation* updates
                
                # if crossFixation is starting this frame...
                if crossFixation.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    crossFixation.frameNStart = frameN  # exact frame index
                    crossFixation.tStart = t  # local t and not account for scr refresh
                    crossFixation.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(crossFixation, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'crossFixation.started')
                    # update status
                    crossFixation.status = STARTED
                    crossFixation.setAutoDraw(True)
                
                # if crossFixation is active this frame...
                if crossFixation.status == STARTED:
                    # update params
                    pass
                
                # if crossFixation is stopping this frame...
                if crossFixation.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > crossFixation.tStartRefresh + fixationLen-frameTolerance:
                        # keep track of stop time/frame for later
                        crossFixation.tStop = t  # not accounting for scr refresh
                        crossFixation.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'crossFixation.stopped')
                        # update status
                        crossFixation.status = FINISHED
                        crossFixation.setAutoDraw(False)
                
                # if fixationCrossMarker is starting this frame...
                if fixationCrossMarker.status == NOT_STARTED and t >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    fixationCrossMarker.frameNStart = frameN  # exact frame index
                    fixationCrossMarker.tStart = t  # local t and not account for scr refresh
                    fixationCrossMarker.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(fixationCrossMarker, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.addData('fixationCrossMarker.started', t)
                    # update status
                    fixationCrossMarker.status = STARTED
                    fixationCrossMarker.status = STARTED
                    delta_time = tThisFlip-t  # Adding the extra time between now and the next screen flip
                    cortex_obj.inject_marker(value=str(fixationVal), label='fixationCross', delta_time=delta_time)
                    fixationCrossMarker.start_sent = True
                
                # if fixationCrossMarker is stopping this frame...
                if fixationCrossMarker.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > fixationCrossMarker.tStartRefresh + fixationLen-frameTolerance:
                        # keep track of stop time/frame for later
                        fixationCrossMarker.tStop = t  # not accounting for scr refresh
                        fixationCrossMarker.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.addData('fixationCrossMarker.stopped', t)
                        # update status
                        fixationCrossMarker.status = FINISHED
                        fixationCrossMarker.status = FINISHED
                
                # check for quit (typically the Esc key)
                if defaultKeyboard.getKeys(keyList=["escape"]):
                    thisExp.status = FINISHED
                if thisExp.status == FINISHED or endExpNow:
                    endExperiment(thisExp, inputs=inputs, win=win)
                    return
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    routineForceEnded = True
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in fixationCrossComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # --- Ending Routine "fixationCross" ---
            for thisComponent in fixationCrossComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            thisExp.addData('fixationCross.stopped', globalClock.getTime())
            # This is generated by the writeRoutineEndCode
            # the Routine "fixationCross" was not non-slip safe, so reset the non-slip timer
            routineTimer.reset()
            
            # --- Prepare to start Routine "stimVid" ---
            continueRoutine = True
            # update component parameters for each repeat
            thisExp.addData('stimVid.started', globalClock.getTime())
            # Run 'Begin Routine' code from codeStim
            print('Trial number: ', counterStim)
            
            print(stimDirList[counterStim])
            print('stim marker val: ', markerValList[counterStim])
            stimMovie.setMovie(stimDirList[counterStim])
            skipStim.keys = []
            skipStim.rt = []
            _skipStim_allKeys = []
            # This is generated by the writeRoutineStartCode
            # keep track of which components have finished
            stimVidComponents = [stimMovie, skipStim, stimMarker]
            for thisComponent in stimVidComponents:
                thisComponent.tStart = None
                thisComponent.tStop = None
                thisComponent.tStartRefresh = None
                thisComponent.tStopRefresh = None
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            # reset timers
            t = 0
            _timeToFirstFrame = win.getFutureFlipTime(clock="now")
            frameN = -1
            
            # --- Run Routine "stimVid" ---
            routineForceEnded = not continueRoutine
            while continueRoutine:
                # get current time
                t = routineTimer.getTime()
                tThisFlip = win.getFutureFlipTime(clock=routineTimer)
                tThisFlipGlobal = win.getFutureFlipTime(clock=None)
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *stimMovie* updates
                
                # if stimMovie is starting this frame...
                if stimMovie.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    stimMovie.frameNStart = frameN  # exact frame index
                    stimMovie.tStart = t  # local t and not account for scr refresh
                    stimMovie.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(stimMovie, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'stimMovie.started')
                    # update status
                    stimMovie.status = STARTED
                    stimMovie.setAutoDraw(True)
                    stimMovie.play()
                if stimMovie.isFinished:  # force-end the Routine
                    continueRoutine = False
                
                # *skipStim* updates
                waitOnFlip = False
                
                # if skipStim is starting this frame...
                if skipStim.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    skipStim.frameNStart = frameN  # exact frame index
                    skipStim.tStart = t  # local t and not account for scr refresh
                    skipStim.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(skipStim, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'skipStim.started')
                    # update status
                    skipStim.status = STARTED
                    # keyboard checking is just starting
                    waitOnFlip = True
                    win.callOnFlip(skipStim.clock.reset)  # t=0 on next screen flip
                    win.callOnFlip(skipStim.clearEvents, eventType='keyboard')  # clear events on next screen flip
                
                # if skipStim is stopping this frame...
                if skipStim.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > skipStim.tStartRefresh + 4.5-frameTolerance:
                        # keep track of stop time/frame for later
                        skipStim.tStop = t  # not accounting for scr refresh
                        skipStim.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.timestampOnFlip(win, 'skipStim.stopped')
                        # update status
                        skipStim.status = FINISHED
                        skipStim.status = FINISHED
                if skipStim.status == STARTED and not waitOnFlip:
                    theseKeys = skipStim.getKeys(keyList=['s'], ignoreKeys=["escape"], waitRelease=False)
                    _skipStim_allKeys.extend(theseKeys)
                    if len(_skipStim_allKeys):
                        skipStim.keys = _skipStim_allKeys[-1].name  # just the last key pressed
                        skipStim.rt = _skipStim_allKeys[-1].rt
                        skipStim.duration = _skipStim_allKeys[-1].duration
                        # a response ends the routine
                        continueRoutine = False
                
                # if stimMarker is starting this frame...
                if stimMarker.status == NOT_STARTED and t >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    stimMarker.frameNStart = frameN  # exact frame index
                    stimMarker.tStart = t  # local t and not account for scr refresh
                    stimMarker.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(stimMarker, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.addData('stimMarker.started', t)
                    # update status
                    stimMarker.status = STARTED
                    stimMarker.status = STARTED
                    delta_time = tThisFlip-t  # Adding the extra time between now and the next screen flip
                    cortex_obj.inject_marker(value=str(markerValList[counterStim]), label=stimList[counterStim], delta_time=delta_time)
                    stimMarker.start_sent = True
                
                # if stimMarker is stopping this frame...
                if stimMarker.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > stimMarker.tStartRefresh + 4.4-frameTolerance:
                        # keep track of stop time/frame for later
                        stimMarker.tStop = t  # not accounting for scr refresh
                        stimMarker.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.addData('stimMarker.stopped', t)
                        # update status
                        stimMarker.status = FINISHED
                        stimMarker.status = FINISHED
                
                # check for quit (typically the Esc key)
                if defaultKeyboard.getKeys(keyList=["escape"]):
                    thisExp.status = FINISHED
                if thisExp.status == FINISHED or endExpNow:
                    endExperiment(thisExp, inputs=inputs, win=win)
                    return
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    routineForceEnded = True
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in stimVidComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # --- Ending Routine "stimVid" ---
            for thisComponent in stimVidComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            thisExp.addData('stimVid.stopped', globalClock.getTime())
            # Run 'End Routine' code from codeStim
            counterStim += 1
            stimMovie.stop()  # ensure movie has stopped at end of Routine
            # check responses
            if skipStim.keys in ['', [], None]:  # No response was made
                skipStim.keys = None
            loopTrial.addData('skipStim.keys',skipStim.keys)
            if skipStim.keys != None:  # we had a response
                loopTrial.addData('skipStim.rt', skipStim.rt)
                loopTrial.addData('skipStim.duration', skipStim.duration)
            # This is generated by the writeRoutineEndCode
            # the Routine "stimVid" was not non-slip safe, so reset the non-slip timer
            routineTimer.reset()
            
            # --- Prepare to start Routine "catchtrialQues" ---
            continueRoutine = True
            # update component parameters for each repeat
            thisExp.addData('catchtrialQues.started', globalClock.getTime())
            # Run 'Begin Routine' code from codeCatchtrial
            if conditionList[counterStim-1] != 'catch':
                continueRoutine = False
            else:
                print("There's a catchtrial here")
             
            objectList = ["Cup", "Hammer", "Toothbrush", "Pencil", "Fork"]
            if catchtrialObjList[counterStim-1] == "none":
                ansNeg = randchoice(objectList)
                ansAffirm = "None"
            else:
                objId = int(catchtrialObjList[counterStim-1][-1])
                print(catchtrialObjList[counterStim-1])
                print(objId)  
                ansAffirm = objectList[objId]
                objectList.pop(objId)
                ansNeg = randchoice(objectList)
                
                
            #Randomize answer's position and key response
            posLeft = (-0.4, -0.1)
            posRight = (0.4, -0.1)
            keyNeg = randchoice(['left', 'right'])
            if keyNeg == 'left':
                posAnsNeg = posLeft
                
                keyAffirm = 'right'
                posAnsAffirm = posRight
            else :
                posAnsNeg = posRight
                
                keyAffirm = 'left'
                posAnsAffirm = posLeft
                
            #print('keyAffirm: ', keyAffirm)
                
                
            
            
                    
                
            
            textAnsAffirm.setPos(posAnsAffirm)
            textAnsAffirm.setText(ansAffirm)
            textAnsNeg.setPos(posAnsNeg)
            textAnsNeg.setText(ansNeg)
            keyRespAffirm.keys = []
            keyRespAffirm.rt = []
            _keyRespAffirm_allKeys = []
            keyRespNeg.keys = []
            keyRespNeg.rt = []
            _keyRespNeg_allKeys = []
            keyRespNoAnswer.keys = []
            keyRespNoAnswer.rt = []
            _keyRespNoAnswer_allKeys = []
            # keep track of which components have finished
            catchtrialQuesComponents = [textQues, textAnsAffirm, textAnsNeg, keyRespAffirm, keyRespNeg, textNoAnswer, keyRespNoAnswer]
            for thisComponent in catchtrialQuesComponents:
                thisComponent.tStart = None
                thisComponent.tStop = None
                thisComponent.tStartRefresh = None
                thisComponent.tStopRefresh = None
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            # reset timers
            t = 0
            _timeToFirstFrame = win.getFutureFlipTime(clock="now")
            frameN = -1
            
            # --- Run Routine "catchtrialQues" ---
            routineForceEnded = not continueRoutine
            while continueRoutine:
                # get current time
                t = routineTimer.getTime()
                tThisFlip = win.getFutureFlipTime(clock=routineTimer)
                tThisFlipGlobal = win.getFutureFlipTime(clock=None)
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *textQues* updates
                
                # if textQues is starting this frame...
                if textQues.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    textQues.frameNStart = frameN  # exact frame index
                    textQues.tStart = t  # local t and not account for scr refresh
                    textQues.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(textQues, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'textQues.started')
                    # update status
                    textQues.status = STARTED
                    textQues.setAutoDraw(True)
                
                # if textQues is active this frame...
                if textQues.status == STARTED:
                    # update params
                    pass
                
                # *textAnsAffirm* updates
                
                # if textAnsAffirm is starting this frame...
                if textAnsAffirm.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    textAnsAffirm.frameNStart = frameN  # exact frame index
                    textAnsAffirm.tStart = t  # local t and not account for scr refresh
                    textAnsAffirm.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(textAnsAffirm, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'textAnsAffirm.started')
                    # update status
                    textAnsAffirm.status = STARTED
                    textAnsAffirm.setAutoDraw(True)
                
                # if textAnsAffirm is active this frame...
                if textAnsAffirm.status == STARTED:
                    # update params
                    pass
                
                # *textAnsNeg* updates
                
                # if textAnsNeg is starting this frame...
                if textAnsNeg.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    textAnsNeg.frameNStart = frameN  # exact frame index
                    textAnsNeg.tStart = t  # local t and not account for scr refresh
                    textAnsNeg.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(textAnsNeg, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'textAnsNeg.started')
                    # update status
                    textAnsNeg.status = STARTED
                    textAnsNeg.setAutoDraw(True)
                
                # if textAnsNeg is active this frame...
                if textAnsNeg.status == STARTED:
                    # update params
                    pass
                
                # *keyRespAffirm* updates
                waitOnFlip = False
                
                # if keyRespAffirm is starting this frame...
                if keyRespAffirm.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    keyRespAffirm.frameNStart = frameN  # exact frame index
                    keyRespAffirm.tStart = t  # local t and not account for scr refresh
                    keyRespAffirm.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(keyRespAffirm, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'keyRespAffirm.started')
                    # update status
                    keyRespAffirm.status = STARTED
                    # AllowedKeys looks like a variable named `keyAffirm`
                    if not type(keyAffirm) in [list, tuple, np.ndarray]:
                        if not isinstance(keyAffirm, str):
                            logging.error('AllowedKeys variable `keyAffirm` is not string- or list-like.')
                            core.quit()
                        elif not ',' in keyAffirm:
                            keyAffirm = (keyAffirm,)
                        else:
                            keyAffirm = eval(keyAffirm)
                    # keyboard checking is just starting
                    waitOnFlip = True
                    win.callOnFlip(keyRespAffirm.clock.reset)  # t=0 on next screen flip
                    win.callOnFlip(keyRespAffirm.clearEvents, eventType='keyboard')  # clear events on next screen flip
                if keyRespAffirm.status == STARTED and not waitOnFlip:
                    theseKeys = keyRespAffirm.getKeys(keyList=list(keyAffirm), ignoreKeys=["escape"], waitRelease=False)
                    _keyRespAffirm_allKeys.extend(theseKeys)
                    if len(_keyRespAffirm_allKeys):
                        keyRespAffirm.keys = _keyRespAffirm_allKeys[-1].name  # just the last key pressed
                        keyRespAffirm.rt = _keyRespAffirm_allKeys[-1].rt
                        keyRespAffirm.duration = _keyRespAffirm_allKeys[-1].duration
                        # a response ends the routine
                        continueRoutine = False
                
                # *keyRespNeg* updates
                waitOnFlip = False
                
                # if keyRespNeg is starting this frame...
                if keyRespNeg.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    keyRespNeg.frameNStart = frameN  # exact frame index
                    keyRespNeg.tStart = t  # local t and not account for scr refresh
                    keyRespNeg.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(keyRespNeg, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'keyRespNeg.started')
                    # update status
                    keyRespNeg.status = STARTED
                    # AllowedKeys looks like a variable named `keyNeg`
                    if not type(keyNeg) in [list, tuple, np.ndarray]:
                        if not isinstance(keyNeg, str):
                            logging.error('AllowedKeys variable `keyNeg` is not string- or list-like.')
                            core.quit()
                        elif not ',' in keyNeg:
                            keyNeg = (keyNeg,)
                        else:
                            keyNeg = eval(keyNeg)
                    # keyboard checking is just starting
                    waitOnFlip = True
                    win.callOnFlip(keyRespNeg.clock.reset)  # t=0 on next screen flip
                    win.callOnFlip(keyRespNeg.clearEvents, eventType='keyboard')  # clear events on next screen flip
                if keyRespNeg.status == STARTED and not waitOnFlip:
                    theseKeys = keyRespNeg.getKeys(keyList=list(keyNeg), ignoreKeys=["escape"], waitRelease=False)
                    _keyRespNeg_allKeys.extend(theseKeys)
                    if len(_keyRespNeg_allKeys):
                        keyRespNeg.keys = _keyRespNeg_allKeys[-1].name  # just the last key pressed
                        keyRespNeg.rt = _keyRespNeg_allKeys[-1].rt
                        keyRespNeg.duration = _keyRespNeg_allKeys[-1].duration
                        # a response ends the routine
                        continueRoutine = False
                
                # *textNoAnswer* updates
                
                # if textNoAnswer is starting this frame...
                if textNoAnswer.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    textNoAnswer.frameNStart = frameN  # exact frame index
                    textNoAnswer.tStart = t  # local t and not account for scr refresh
                    textNoAnswer.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(textNoAnswer, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'textNoAnswer.started')
                    # update status
                    textNoAnswer.status = STARTED
                    textNoAnswer.setAutoDraw(True)
                
                # if textNoAnswer is active this frame...
                if textNoAnswer.status == STARTED:
                    # update params
                    pass
                
                # *keyRespNoAnswer* updates
                waitOnFlip = False
                
                # if keyRespNoAnswer is starting this frame...
                if keyRespNoAnswer.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    keyRespNoAnswer.frameNStart = frameN  # exact frame index
                    keyRespNoAnswer.tStart = t  # local t and not account for scr refresh
                    keyRespNoAnswer.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(keyRespNoAnswer, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'keyRespNoAnswer.started')
                    # update status
                    keyRespNoAnswer.status = STARTED
                    # keyboard checking is just starting
                    waitOnFlip = True
                    win.callOnFlip(keyRespNoAnswer.clock.reset)  # t=0 on next screen flip
                    win.callOnFlip(keyRespNoAnswer.clearEvents, eventType='keyboard')  # clear events on next screen flip
                if keyRespNoAnswer.status == STARTED and not waitOnFlip:
                    theseKeys = keyRespNoAnswer.getKeys(keyList=['down'], ignoreKeys=["escape"], waitRelease=False)
                    _keyRespNoAnswer_allKeys.extend(theseKeys)
                    if len(_keyRespNoAnswer_allKeys):
                        keyRespNoAnswer.keys = _keyRespNoAnswer_allKeys[-1].name  # just the last key pressed
                        keyRespNoAnswer.rt = _keyRespNoAnswer_allKeys[-1].rt
                        keyRespNoAnswer.duration = _keyRespNoAnswer_allKeys[-1].duration
                        # a response ends the routine
                        continueRoutine = False
                
                # check for quit (typically the Esc key)
                if defaultKeyboard.getKeys(keyList=["escape"]):
                    thisExp.status = FINISHED
                if thisExp.status == FINISHED or endExpNow:
                    endExperiment(thisExp, inputs=inputs, win=win)
                    return
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    routineForceEnded = True
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in catchtrialQuesComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # --- Ending Routine "catchtrialQues" ---
            for thisComponent in catchtrialQuesComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            thisExp.addData('catchtrialQues.stopped', globalClock.getTime())
            # check responses
            if keyRespAffirm.keys in ['', [], None]:  # No response was made
                keyRespAffirm.keys = None
            loopTrial.addData('keyRespAffirm.keys',keyRespAffirm.keys)
            if keyRespAffirm.keys != None:  # we had a response
                loopTrial.addData('keyRespAffirm.rt', keyRespAffirm.rt)
                loopTrial.addData('keyRespAffirm.duration', keyRespAffirm.duration)
            # check responses
            if keyRespNeg.keys in ['', [], None]:  # No response was made
                keyRespNeg.keys = None
            loopTrial.addData('keyRespNeg.keys',keyRespNeg.keys)
            if keyRespNeg.keys != None:  # we had a response
                loopTrial.addData('keyRespNeg.rt', keyRespNeg.rt)
                loopTrial.addData('keyRespNeg.duration', keyRespNeg.duration)
            # check responses
            if keyRespNoAnswer.keys in ['', [], None]:  # No response was made
                keyRespNoAnswer.keys = None
            loopTrial.addData('keyRespNoAnswer.keys',keyRespNoAnswer.keys)
            if keyRespNoAnswer.keys != None:  # we had a response
                loopTrial.addData('keyRespNoAnswer.rt', keyRespNoAnswer.rt)
                loopTrial.addData('keyRespNoAnswer.duration', keyRespNoAnswer.duration)
            # the Routine "catchtrialQues" was not non-slip safe, so reset the non-slip timer
            routineTimer.reset()
            
            # --- Prepare to start Routine "markCTanswer" ---
            continueRoutine = True
            # update component parameters for each repeat
            thisExp.addData('markCTanswer.started', globalClock.getTime())
            # Run 'Begin Routine' code from codeGetAnswer
            if conditionList[counterStim-1] != 'catch':
                continueRoutine = False
                keyPressed = ""
                statusPress = ""
                answerCTVal = 0
            else:
                keyPressed = event.getKeys()
                print(keyPressed)
                if keyPressed == []:
                    keyPressed = 'none'
                else:    
                    keyPressed = str(keyPressed[-1])
                
                keyAffirm = str(keyAffirm[0])
                print('keyPressed: ', keyPressed)
                print('keyAffirm: ', keyAffirm)
                if keyPressed == str(keyAffirm):
                    statusPress = "Correct!"
                    answerCTVal = 201
                else:
                    statusPress = "Incorrect!"
                    answerCTVal = 200
                print('statusPress: ', statusPress)
                print('answerCTVal: ', answerCTVal)
                 
            # This is generated by the writeRoutineStartCode
            # keep track of which components have finished
            markCTanswerComponents = [CTmarker]
            for thisComponent in markCTanswerComponents:
                thisComponent.tStart = None
                thisComponent.tStop = None
                thisComponent.tStartRefresh = None
                thisComponent.tStopRefresh = None
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            # reset timers
            t = 0
            _timeToFirstFrame = win.getFutureFlipTime(clock="now")
            frameN = -1
            
            # --- Run Routine "markCTanswer" ---
            routineForceEnded = not continueRoutine
            while continueRoutine and routineTimer.getTime() < 0.1:
                # get current time
                t = routineTimer.getTime()
                tThisFlip = win.getFutureFlipTime(clock=routineTimer)
                tThisFlipGlobal = win.getFutureFlipTime(clock=None)
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # if CTmarker is starting this frame...
                if CTmarker.status == NOT_STARTED and t >= 0.0-frameTolerance:
                    # keep track of start time/frame for later
                    CTmarker.frameNStart = frameN  # exact frame index
                    CTmarker.tStart = t  # local t and not account for scr refresh
                    CTmarker.tStartRefresh = tThisFlipGlobal  # on global time
                    win.timeOnFlip(CTmarker, 'tStartRefresh')  # time at next scr refresh
                    # add timestamp to datafile
                    thisExp.addData('CTmarker.started', t)
                    # update status
                    CTmarker.status = STARTED
                    CTmarker.status = STARTED
                    delta_time = tThisFlip-t  # Adding the extra time between now and the next screen flip
                    cortex_obj.inject_marker(value=str(answerCTVal), label='answerCT', delta_time=delta_time)
                    CTmarker.start_sent = True
                
                # if CTmarker is stopping this frame...
                if CTmarker.status == STARTED:
                    # is it time to stop? (based on global clock, using actual start)
                    if tThisFlipGlobal > CTmarker.tStartRefresh + 0.1-frameTolerance:
                        # keep track of stop time/frame for later
                        CTmarker.tStop = t  # not accounting for scr refresh
                        CTmarker.frameNStop = frameN  # exact frame index
                        # add timestamp to datafile
                        thisExp.addData('CTmarker.stopped', t)
                        # update status
                        CTmarker.status = FINISHED
                        CTmarker.status = FINISHED
                        # delta_time = tThisFlip-t  # Adding the extra time between now and the next screen flip
                        # cortex_obj.update_marker(label='answerCT', delta_time=delta_time)
                


                
                # check for quit (typically the Esc key)
                if defaultKeyboard.getKeys(keyList=["escape"]):
                    thisExp.status = FINISHED
                if thisExp.status == FINISHED or endExpNow:
                    endExperiment(thisExp, inputs=inputs, win=win)
                    return
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    routineForceEnded = True
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in markCTanswerComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # --- Ending Routine "markCTanswer" ---
            for thisComponent in markCTanswerComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            thisExp.addData('markCTanswer.stopped', globalClock.getTime())
            # This is generated by the writeRoutineEndCode
            # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
            if routineForceEnded:
                routineTimer.reset()
            else:
                routineTimer.addTime(-0.100000)
            
            # --- Prepare to start Routine "postStimInterval" ---
            continueRoutine = True
            # update component parameters for each repeat
            thisExp.addData('postStimInterval.started', globalClock.getTime())
            # Run 'Begin Routine' code from codePostStim
            if counterStim < N_trial:
                continueRoutine = False
            # keep track of which components have finished
            postStimIntervalComponents = []
            for thisComponent in postStimIntervalComponents:
                thisComponent.tStart = None
                thisComponent.tStop = None
                thisComponent.tStartRefresh = None
                thisComponent.tStopRefresh = None
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            # reset timers
            t = 0
            _timeToFirstFrame = win.getFutureFlipTime(clock="now")
            frameN = -1
            
            # --- Run Routine "postStimInterval" ---
            routineForceEnded = not continueRoutine
            while continueRoutine:
                # get current time
                t = routineTimer.getTime()
                tThisFlip = win.getFutureFlipTime(clock=routineTimer)
                tThisFlipGlobal = win.getFutureFlipTime(clock=None)
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # check for quit (typically the Esc key)
                if defaultKeyboard.getKeys(keyList=["escape"]):
                    thisExp.status = FINISHED
                if thisExp.status == FINISHED or endExpNow:
                    endExperiment(thisExp, inputs=inputs, win=win)
                    return
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    routineForceEnded = True
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in postStimIntervalComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # --- Ending Routine "postStimInterval" ---
            for thisComponent in postStimIntervalComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            thisExp.addData('postStimInterval.stopped', globalClock.getTime())
            # the Routine "postStimInterval" was not non-slip safe, so reset the non-slip timer
            routineTimer.reset()
            thisExp.nextEntry()
            
            if thisSession is not None:
                # if running in a Session with a Liaison client, send data up to now
                thisSession.sendExperimentData()
        # completed N_trial repeats of 'loopTrial'
        
        
        # --- Prepare to start Routine "endBlock" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('endBlock.started', globalClock.getTime())
        # Run 'Begin Routine' code from codeEndBlock
        counterBlock += 1
        # keep track of which components have finished
        endBlockComponents = []
        for thisComponent in endBlockComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        frameN = -1
        
        # --- Run Routine "endBlock" ---
        routineForceEnded = not continueRoutine
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # check for quit (typically the Esc key)
            if defaultKeyboard.getKeys(keyList=["escape"]):
                thisExp.status = FINISHED
            if thisExp.status == FINISHED or endExpNow:
                endExperiment(thisExp, inputs=inputs, win=win)
                return
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                routineForceEnded = True
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in endBlockComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "endBlock" ---
        for thisComponent in endBlockComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('endBlock.stopped', globalClock.getTime())
        # Run 'End Routine' code from codeEndBlock
        breakCD = breakLength
        # the Routine "endBlock" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        thisExp.nextEntry()
        
        if thisSession is not None:
            # if running in a Session with a Liaison client, send data up to now
            thisSession.sendExperimentData()
    # completed N_block repeats of 'loopBlock'
    
    
    # --- Prepare to start Routine "endExperiment" ---
    continueRoutine = True
    # update component parameters for each repeat
    thisExp.addData('endExperiment.started', globalClock.getTime())
    keyQuit.keys = []
    keyQuit.rt = []
    _keyQuit_allKeys = []
    # keep track of which components have finished
    endExperimentComponents = [textEnd, keyQuit]
    for thisComponent in endExperimentComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1
    
    # --- Run Routine "endExperiment" ---
    routineForceEnded = not continueRoutine
    while continueRoutine and routineTimer.getTime() < 15.0:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *textEnd* updates
        
        # if textEnd is starting this frame...
        if textEnd.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            textEnd.frameNStart = frameN  # exact frame index
            textEnd.tStart = t  # local t and not account for scr refresh
            textEnd.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(textEnd, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'textEnd.started')
            # update status
            textEnd.status = STARTED
            textEnd.setAutoDraw(True)
        
        # if textEnd is active this frame...
        if textEnd.status == STARTED:
            # update params
            pass
        
        # if textEnd is stopping this frame...
        if textEnd.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > textEnd.tStartRefresh + 15-frameTolerance:
                # keep track of stop time/frame for later
                textEnd.tStop = t  # not accounting for scr refresh
                textEnd.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'textEnd.stopped')
                # update status
                textEnd.status = FINISHED
                textEnd.setAutoDraw(False)
        
        # *keyQuit* updates
        waitOnFlip = False
        
        # if keyQuit is starting this frame...
        if keyQuit.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            keyQuit.frameNStart = frameN  # exact frame index
            keyQuit.tStart = t  # local t and not account for scr refresh
            keyQuit.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(keyQuit, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'keyQuit.started')
            # update status
            keyQuit.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(keyQuit.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(keyQuit.clearEvents, eventType='keyboard')  # clear events on next screen flip
        
        # if keyQuit is stopping this frame...
        if keyQuit.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > keyQuit.tStartRefresh + 15-frameTolerance:
                # keep track of stop time/frame for later
                keyQuit.tStop = t  # not accounting for scr refresh
                keyQuit.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'keyQuit.stopped')
                # update status
                keyQuit.status = FINISHED
                keyQuit.status = FINISHED
        if keyQuit.status == STARTED and not waitOnFlip:
            theseKeys = keyQuit.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _keyQuit_allKeys.extend(theseKeys)
            if len(_keyQuit_allKeys):
                keyQuit.keys = _keyQuit_allKeys[-1].name  # just the last key pressed
                keyQuit.rt = _keyQuit_allKeys[-1].rt
                keyQuit.duration = _keyQuit_allKeys[-1].duration
                # a response ends the routine
                continueRoutine = False
        
        # check for quit (typically the Esc key)
        if defaultKeyboard.getKeys(keyList=["escape"]):
            thisExp.status = FINISHED
        if thisExp.status == FINISHED or endExpNow:
            endExperiment(thisExp, inputs=inputs, win=win)
            return
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in endExperimentComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "endExperiment" ---
    for thisComponent in endExperimentComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    thisExp.addData('endExperiment.stopped', globalClock.getTime())
    # check responses
    if keyQuit.keys in ['', [], None]:  # No response was made
        keyQuit.keys = None
    thisExp.addData('keyQuit.keys',keyQuit.keys)
    if keyQuit.keys != None:  # we had a response
        thisExp.addData('keyQuit.rt', keyQuit.rt)
        thisExp.addData('keyQuit.duration', keyQuit.duration)
    thisExp.nextEntry()
    # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
    if routineForceEnded:
        routineTimer.reset()
    else:
        routineTimer.addTime(-15.000000)
    core.wait(1) # Wait for EEG data to be packaged
    cortex_obj.close_session()
    
    # mark experiment as finished
    endExperiment(thisExp, win=win, inputs=inputs)


def saveData(thisExp):
    """
    Save data from this experiment
    
    Parameters
    ==========
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about 
        where to save it to.
    """
    filename = thisExp.dataFileName
    # these shouldn't be strictly necessary (should auto-save)
    thisExp.saveAsWideText(filename + '.csv', delim='auto')
    thisExp.saveAsPickle(filename)


def endExperiment(thisExp, inputs=None, win=None):
    """
    End this experiment, performing final shut down operations.
    
    This function does NOT close the window or end the Python process - use `quit` for this.
    
    Parameters
    ==========
    thisExp : psychopy.data.ExperimentHandler
        Handler object for this experiment, contains the data to save and information about 
        where to save it to.
    inputs : dict
        Dictionary of input devices by name.
    win : psychopy.visual.Window
        Window for this experiment.
    """
    if win is not None:
        # remove autodraw from all current components
        win.clearAutoDraw()
        # Flip one final time so any remaining win.callOnFlip() 
        # and win.timeOnFlip() tasks get executed
        win.flip()
    # mark experiment handler as finished
    thisExp.status = FINISHED
    # shut down eyetracker, if there is one
    if inputs is not None:
        if 'eyetracker' in inputs and inputs['eyetracker'] is not None:
            inputs['eyetracker'].setConnectionState(False)
    logging.flush()


def quit(thisExp, win=None, inputs=None, thisSession=None):
    """
    Fully quit, closing the window and ending the Python process.
    
    Parameters
    ==========
    win : psychopy.visual.Window
        Window to close.
    inputs : dict
        Dictionary of input devices by name.
    thisSession : psychopy.session.Session or None
        Handle of the Session object this experiment is being run from, if any.
    """
    thisExp.abort()  # or data files will save again on exit
    # make sure everything is closed down
    if win is not None:
        # Flip one final time so any remaining win.callOnFlip() 
        # and win.timeOnFlip() tasks get executed before quitting
        win.flip()
        win.close()
    if inputs is not None:
        if 'eyetracker' in inputs and inputs['eyetracker'] is not None:
            inputs['eyetracker'].setConnectionState(False)
    logging.flush()
    if thisSession is not None:
        thisSession.stop()
    # terminate Python process
    core.quit()


# if running this experiment as a script...
if __name__ == '__main__':
    # call all functions in order
    expInfo = showExpInfoDlg(expInfo=expInfo)
    thisExp = setupData(expInfo=expInfo)
    logFile = setupLogging(filename=thisExp.dataFileName)
    win = setupWindow(expInfo=expInfo)
    inputs = setupInputs(expInfo=expInfo, thisExp=thisExp, win=win)
    run(
        expInfo=expInfo, 
        thisExp=thisExp, 
        win=win, 
        inputs=inputs
    )
    saveData(thisExp=thisExp)
    quit(thisExp=thisExp, win=win, inputs=inputs)
