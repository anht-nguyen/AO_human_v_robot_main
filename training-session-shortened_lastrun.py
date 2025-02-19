#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v2023.2.3),
    on November 18, 2024, at 18:09
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

# --- Setup global variables (available in all functions) ---
# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
# Store info about the experiment session
psychopyVersion = '2023.2.3'
expName = 'practice-session'  # from the Builder filename that created this script
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
        originPath='C:\\Users\\anhtn\\OneDrive - PennO365\\Documents\\GitHub\\AO_human_v_robot_main\\training-session-shortened_lastrun.py',
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
            size=[2560, 1440], fullscr=True, screen=1,
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
    win.mouseVisible = False
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
    
    # --- Initialize components for Routine "loadStim" ---
    # Run 'Begin Experiment' code from codeLoadStim
    conditionList = []
    stimDirList = []
    catchtrialObjList = []
    
    N_stim = 10
    N_catch = 10
    
    # --- Initialize components for Routine "startScreen" ---
    textWelcome = visual.TextStim(win=win, name='textWelcome',
        text="Welcome to the study and \n\nThank you for your participation!\n\n\n\nReminder, your participation is voluntary.\n\n\n\nLet's now prepare for the experiments! \n\nPress Space to continue >>>",
        font='Open Sans',
        pos=(0, 0.1), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=0.0);
    keySkipWelcome = keyboard.Keyboard()
    
    # --- Initialize components for Routine "putOnEEG" ---
    textEEGsetup = visual.TextStim(win=win, name='textEEGsetup',
        text="Let's prepare to place the EEG headset on you.\n\nWe need to make sure we have good contact quality.\n\n\n\nNext, please fixate on a cross centered on the screen >>>",
        font='Open Sans',
        pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=0.0);
    keySkipEEGsetup = keyboard.Keyboard()
    
    # --- Initialize components for Routine "checkEEGquality" ---
    fixate2CheckEEG = visual.ShapeStim(
        win=win, name='fixate2CheckEEG', vertices='cross',
        size=(0.1, 0.1),
        ori=0.0, pos=(0, 0), anchor='center',
        lineWidth=1.0,     colorSpace='rgb',  lineColor='white', fillColor='white',
        opacity=None, depth=0.0, interpolate=True)
    textCheckEEG = visual.TextStim(win=win, name='textCheckEEG',
        text='Fixate on the cross for few seconds\n\nTry not to move and not to blink',
        font='Open Sans',
        pos=(0, .25), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-1.0);
    keySkipEEGcheck = keyboard.Keyboard()
    
    # --- Initialize components for Routine "beginTraining" ---
    textBeginTraining = visual.TextStim(win=win, name='textBeginTraining',
        text="Let's begin the training!\n\nPlease follow the instructions to get you used to the experiments.\n",
        font='Open Sans',
        pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=0.0);
    skipBeginTraining = keyboard.Keyboard()
    # Run 'Begin Experiment' code from codeTrainingSetup
    counterStim = 0
    
    # --- Initialize components for Routine "introExp2" ---
    textIntroExp2 = visual.TextStim(win=win, name='textIntroExp2',
        text="In Experiment 2,\n\nyou'll be asked to OBSERVE action video then IMITATE the action.\n\n\nIn each trial, the order will be:\nAction Video => Fixation Cross => Imitation => Rest\n\n\nLet's practice!\n\nPress Space to continue  >>>",
        font='Open Sans',
        pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=0.0);
    keyIntroExp2 = keyboard.Keyboard()
    
    # --- Initialize components for Routine "fixationCross_train1" ---
    fixationCross0 = visual.ShapeStim(
        win=win, name='fixationCross0', vertices='cross',
        size=(0.1, 0.1),
        ori=0.0, pos=(0, 0), anchor='center',
        lineWidth=1.0,     colorSpace='rgb',  lineColor='white', fillColor='white',
        opacity=None, depth=0.0, interpolate=True)
    keySkipS = keyboard.Keyboard()
    
    # --- Initialize components for Routine "stimVid_train1" ---
    stimVid_train = visual.MovieStim(
        win, name='stimVid_train',
        filename=None, movieLib='ffpyplayer',
        loop=False, volume=1.0, noAudio=True,
        pos=(0, 0), size=(1.125, 0.63), units=win.units,
        ori=0.0, anchor='center',opacity=None, contrast=1.0,
        depth=0
    )
    keySkipS_2 = keyboard.Keyboard()
    
    # --- Initialize components for Routine "fixationCross_train1" ---
    fixationCross0 = visual.ShapeStim(
        win=win, name='fixationCross0', vertices='cross',
        size=(0.1, 0.1),
        ori=0.0, pos=(0, 0), anchor='center',
        lineWidth=1.0,     colorSpace='rgb',  lineColor='white', fillColor='white',
        opacity=None, depth=0.0, interpolate=True)
    keySkipS = keyboard.Keyboard()
    
    # --- Initialize components for Routine "executionPhase" ---
    executionCircle = visual.ShapeStim(
        win=win, name='executionCircle',
        size=(0.25, 0.25), vertices='triangle',
        ori=90.0, pos=(0, 0), anchor='center',
        lineWidth=1.0,     colorSpace='rgb',  lineColor='white', fillColor='white',
        opacity=None, depth=0.0, interpolate=True)
    text = visual.TextStim(win=win, name='text',
        text='Imitate the last seen action\n\nwhen you see a circle.',
        font='Open Sans',
        pos=(0, .3), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=-1.0);
    
    # --- Initialize components for Routine "ITI_train1" ---
    ITI_train = visual.TextStim(win=win, name='ITI_train',
        text=None,
        font='Open Sans',
        pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=0.0);
    keySkipS_3 = keyboard.Keyboard()
    
    # --- Initialize components for Routine "endTrain1" ---
    textEndTrain1 = visual.TextStim(win=win, name='textEndTrain1',
        text='Good job!\n\nLet us know if you have any questions.\n\n\n\nIf not, Press Space to continue >>>',
        font='Open Sans',
        pos=(0, 0), height=0.05, wrapWidth=None, ori=0.0, 
        color='white', colorSpace='rgb', opacity=None, 
        languageStyle='LTR',
        depth=0.0);
    keyEndTrain1 = keyboard.Keyboard()
    
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
    loadStimLoop = data.TrialHandler(nReps=1.0, method='sequential', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions('trial_files/training_randomized_trials - legacy.xlsx'),
        seed=None, name='loadStimLoop')
    thisExp.addLoop(loadStimLoop)  # add the loop to the experiment
    thisLoadStimLoop = loadStimLoop.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisLoadStimLoop.rgb)
    if thisLoadStimLoop != None:
        for paramName in thisLoadStimLoop:
            globals()[paramName] = thisLoadStimLoop[paramName]
    
    for thisLoadStimLoop in loadStimLoop:
        currentLoop = loadStimLoop
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
        # abbreviate parameter names if possible (e.g. rgb = thisLoadStimLoop.rgb)
        if thisLoadStimLoop != None:
            for paramName in thisLoadStimLoop:
                globals()[paramName] = thisLoadStimLoop[paramName]
        
        # --- Prepare to start Routine "loadStim" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('loadStim.started', globalClock.getTime())
        # Run 'Begin Routine' code from codeLoadStim
        conditionList.append(condition)
        stimDirList.append(stimDir)
        catchtrialObjList.append(catchtrialObj)
        # keep track of which components have finished
        loadStimComponents = []
        for thisComponent in loadStimComponents:
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
        
        # --- Run Routine "loadStim" ---
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
            for thisComponent in loadStimComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "loadStim" ---
        for thisComponent in loadStimComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('loadStim.stopped', globalClock.getTime())
        # the Routine "loadStim" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
    # completed 1.0 repeats of 'loadStimLoop'
    
    
    # --- Prepare to start Routine "startScreen" ---
    continueRoutine = True
    # update component parameters for each repeat
    thisExp.addData('startScreen.started', globalClock.getTime())
    keySkipWelcome.keys = []
    keySkipWelcome.rt = []
    _keySkipWelcome_allKeys = []
    # keep track of which components have finished
    startScreenComponents = [textWelcome, keySkipWelcome]
    for thisComponent in startScreenComponents:
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
    
    # --- Run Routine "startScreen" ---
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
        
        # *keySkipWelcome* updates
        waitOnFlip = False
        
        # if keySkipWelcome is starting this frame...
        if keySkipWelcome.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            keySkipWelcome.frameNStart = frameN  # exact frame index
            keySkipWelcome.tStart = t  # local t and not account for scr refresh
            keySkipWelcome.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(keySkipWelcome, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'keySkipWelcome.started')
            # update status
            keySkipWelcome.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(keySkipWelcome.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(keySkipWelcome.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if keySkipWelcome.status == STARTED and not waitOnFlip:
            theseKeys = keySkipWelcome.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _keySkipWelcome_allKeys.extend(theseKeys)
            if len(_keySkipWelcome_allKeys):
                keySkipWelcome.keys = _keySkipWelcome_allKeys[-1].name  # just the last key pressed
                keySkipWelcome.rt = _keySkipWelcome_allKeys[-1].rt
                keySkipWelcome.duration = _keySkipWelcome_allKeys[-1].duration
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
        for thisComponent in startScreenComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "startScreen" ---
    for thisComponent in startScreenComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    thisExp.addData('startScreen.stopped', globalClock.getTime())
    # check responses
    if keySkipWelcome.keys in ['', [], None]:  # No response was made
        keySkipWelcome.keys = None
    thisExp.addData('keySkipWelcome.keys',keySkipWelcome.keys)
    if keySkipWelcome.keys != None:  # we had a response
        thisExp.addData('keySkipWelcome.rt', keySkipWelcome.rt)
        thisExp.addData('keySkipWelcome.duration', keySkipWelcome.duration)
    thisExp.nextEntry()
    # the Routine "startScreen" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # --- Prepare to start Routine "putOnEEG" ---
    continueRoutine = True
    # update component parameters for each repeat
    thisExp.addData('putOnEEG.started', globalClock.getTime())
    keySkipEEGsetup.keys = []
    keySkipEEGsetup.rt = []
    _keySkipEEGsetup_allKeys = []
    # keep track of which components have finished
    putOnEEGComponents = [textEEGsetup, keySkipEEGsetup]
    for thisComponent in putOnEEGComponents:
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
    
    # --- Run Routine "putOnEEG" ---
    routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *textEEGsetup* updates
        
        # if textEEGsetup is starting this frame...
        if textEEGsetup.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            textEEGsetup.frameNStart = frameN  # exact frame index
            textEEGsetup.tStart = t  # local t and not account for scr refresh
            textEEGsetup.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(textEEGsetup, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'textEEGsetup.started')
            # update status
            textEEGsetup.status = STARTED
            textEEGsetup.setAutoDraw(True)
        
        # if textEEGsetup is active this frame...
        if textEEGsetup.status == STARTED:
            # update params
            pass
        
        # *keySkipEEGsetup* updates
        waitOnFlip = False
        
        # if keySkipEEGsetup is starting this frame...
        if keySkipEEGsetup.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            keySkipEEGsetup.frameNStart = frameN  # exact frame index
            keySkipEEGsetup.tStart = t  # local t and not account for scr refresh
            keySkipEEGsetup.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(keySkipEEGsetup, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'keySkipEEGsetup.started')
            # update status
            keySkipEEGsetup.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(keySkipEEGsetup.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(keySkipEEGsetup.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if keySkipEEGsetup.status == STARTED and not waitOnFlip:
            theseKeys = keySkipEEGsetup.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _keySkipEEGsetup_allKeys.extend(theseKeys)
            if len(_keySkipEEGsetup_allKeys):
                keySkipEEGsetup.keys = _keySkipEEGsetup_allKeys[-1].name  # just the last key pressed
                keySkipEEGsetup.rt = _keySkipEEGsetup_allKeys[-1].rt
                keySkipEEGsetup.duration = _keySkipEEGsetup_allKeys[-1].duration
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
        for thisComponent in putOnEEGComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "putOnEEG" ---
    for thisComponent in putOnEEGComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    thisExp.addData('putOnEEG.stopped', globalClock.getTime())
    # check responses
    if keySkipEEGsetup.keys in ['', [], None]:  # No response was made
        keySkipEEGsetup.keys = None
    thisExp.addData('keySkipEEGsetup.keys',keySkipEEGsetup.keys)
    if keySkipEEGsetup.keys != None:  # we had a response
        thisExp.addData('keySkipEEGsetup.rt', keySkipEEGsetup.rt)
        thisExp.addData('keySkipEEGsetup.duration', keySkipEEGsetup.duration)
    thisExp.nextEntry()
    # the Routine "putOnEEG" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # --- Prepare to start Routine "checkEEGquality" ---
    continueRoutine = True
    # update component parameters for each repeat
    thisExp.addData('checkEEGquality.started', globalClock.getTime())
    keySkipEEGcheck.keys = []
    keySkipEEGcheck.rt = []
    _keySkipEEGcheck_allKeys = []
    # keep track of which components have finished
    checkEEGqualityComponents = [fixate2CheckEEG, textCheckEEG, keySkipEEGcheck]
    for thisComponent in checkEEGqualityComponents:
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
    
    # --- Run Routine "checkEEGquality" ---
    routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *fixate2CheckEEG* updates
        
        # if fixate2CheckEEG is starting this frame...
        if fixate2CheckEEG.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            fixate2CheckEEG.frameNStart = frameN  # exact frame index
            fixate2CheckEEG.tStart = t  # local t and not account for scr refresh
            fixate2CheckEEG.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(fixate2CheckEEG, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'fixate2CheckEEG.started')
            # update status
            fixate2CheckEEG.status = STARTED
            fixate2CheckEEG.setAutoDraw(True)
        
        # if fixate2CheckEEG is active this frame...
        if fixate2CheckEEG.status == STARTED:
            # update params
            pass
        
        # *textCheckEEG* updates
        
        # if textCheckEEG is starting this frame...
        if textCheckEEG.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            textCheckEEG.frameNStart = frameN  # exact frame index
            textCheckEEG.tStart = t  # local t and not account for scr refresh
            textCheckEEG.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(textCheckEEG, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'textCheckEEG.started')
            # update status
            textCheckEEG.status = STARTED
            textCheckEEG.setAutoDraw(True)
        
        # if textCheckEEG is active this frame...
        if textCheckEEG.status == STARTED:
            # update params
            pass
        
        # *keySkipEEGcheck* updates
        waitOnFlip = False
        
        # if keySkipEEGcheck is starting this frame...
        if keySkipEEGcheck.status == NOT_STARTED and tThisFlip >= 5-frameTolerance:
            # keep track of start time/frame for later
            keySkipEEGcheck.frameNStart = frameN  # exact frame index
            keySkipEEGcheck.tStart = t  # local t and not account for scr refresh
            keySkipEEGcheck.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(keySkipEEGcheck, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'keySkipEEGcheck.started')
            # update status
            keySkipEEGcheck.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(keySkipEEGcheck.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(keySkipEEGcheck.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if keySkipEEGcheck.status == STARTED and not waitOnFlip:
            theseKeys = keySkipEEGcheck.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _keySkipEEGcheck_allKeys.extend(theseKeys)
            if len(_keySkipEEGcheck_allKeys):
                keySkipEEGcheck.keys = _keySkipEEGcheck_allKeys[-1].name  # just the last key pressed
                keySkipEEGcheck.rt = _keySkipEEGcheck_allKeys[-1].rt
                keySkipEEGcheck.duration = _keySkipEEGcheck_allKeys[-1].duration
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
        for thisComponent in checkEEGqualityComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "checkEEGquality" ---
    for thisComponent in checkEEGqualityComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    thisExp.addData('checkEEGquality.stopped', globalClock.getTime())
    # check responses
    if keySkipEEGcheck.keys in ['', [], None]:  # No response was made
        keySkipEEGcheck.keys = None
    thisExp.addData('keySkipEEGcheck.keys',keySkipEEGcheck.keys)
    if keySkipEEGcheck.keys != None:  # we had a response
        thisExp.addData('keySkipEEGcheck.rt', keySkipEEGcheck.rt)
        thisExp.addData('keySkipEEGcheck.duration', keySkipEEGcheck.duration)
    thisExp.nextEntry()
    # the Routine "checkEEGquality" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # --- Prepare to start Routine "beginTraining" ---
    continueRoutine = True
    # update component parameters for each repeat
    thisExp.addData('beginTraining.started', globalClock.getTime())
    skipBeginTraining.keys = []
    skipBeginTraining.rt = []
    _skipBeginTraining_allKeys = []
    # Run 'Begin Routine' code from codeTrainingSetup
    stimDirList_exp = stimDirList[:N_stim]
    stimDirList_catch = stimDirList[N_stim:]
    #catchtrialObjList = catchtrialObjList[N_stim:]
    
    print(catchtrialObjList)
    print(stimDirList)
    
    # keep track of which components have finished
    beginTrainingComponents = [textBeginTraining, skipBeginTraining]
    for thisComponent in beginTrainingComponents:
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
    
    # --- Run Routine "beginTraining" ---
    routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *textBeginTraining* updates
        
        # if textBeginTraining is starting this frame...
        if textBeginTraining.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            textBeginTraining.frameNStart = frameN  # exact frame index
            textBeginTraining.tStart = t  # local t and not account for scr refresh
            textBeginTraining.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(textBeginTraining, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'textBeginTraining.started')
            # update status
            textBeginTraining.status = STARTED
            textBeginTraining.setAutoDraw(True)
        
        # if textBeginTraining is active this frame...
        if textBeginTraining.status == STARTED:
            # update params
            pass
        
        # *skipBeginTraining* updates
        waitOnFlip = False
        
        # if skipBeginTraining is starting this frame...
        if skipBeginTraining.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            skipBeginTraining.frameNStart = frameN  # exact frame index
            skipBeginTraining.tStart = t  # local t and not account for scr refresh
            skipBeginTraining.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(skipBeginTraining, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'skipBeginTraining.started')
            # update status
            skipBeginTraining.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(skipBeginTraining.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(skipBeginTraining.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if skipBeginTraining.status == STARTED and not waitOnFlip:
            theseKeys = skipBeginTraining.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _skipBeginTraining_allKeys.extend(theseKeys)
            if len(_skipBeginTraining_allKeys):
                skipBeginTraining.keys = _skipBeginTraining_allKeys[-1].name  # just the last key pressed
                skipBeginTraining.rt = _skipBeginTraining_allKeys[-1].rt
                skipBeginTraining.duration = _skipBeginTraining_allKeys[-1].duration
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
        for thisComponent in beginTrainingComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "beginTraining" ---
    for thisComponent in beginTrainingComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    thisExp.addData('beginTraining.stopped', globalClock.getTime())
    # check responses
    if skipBeginTraining.keys in ['', [], None]:  # No response was made
        skipBeginTraining.keys = None
    thisExp.addData('skipBeginTraining.keys',skipBeginTraining.keys)
    if skipBeginTraining.keys != None:  # we had a response
        thisExp.addData('skipBeginTraining.rt', skipBeginTraining.rt)
        thisExp.addData('skipBeginTraining.duration', skipBeginTraining.duration)
    thisExp.nextEntry()
    # the Routine "beginTraining" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # --- Prepare to start Routine "introExp2" ---
    continueRoutine = True
    # update component parameters for each repeat
    thisExp.addData('introExp2.started', globalClock.getTime())
    keyIntroExp2.keys = []
    keyIntroExp2.rt = []
    _keyIntroExp2_allKeys = []
    # Run 'Begin Routine' code from codeIntroExp2
    counterStim = 0
    
    
    # keep track of which components have finished
    introExp2Components = [textIntroExp2, keyIntroExp2]
    for thisComponent in introExp2Components:
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
    
    # --- Run Routine "introExp2" ---
    routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *textIntroExp2* updates
        
        # if textIntroExp2 is starting this frame...
        if textIntroExp2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            textIntroExp2.frameNStart = frameN  # exact frame index
            textIntroExp2.tStart = t  # local t and not account for scr refresh
            textIntroExp2.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(textIntroExp2, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'textIntroExp2.started')
            # update status
            textIntroExp2.status = STARTED
            textIntroExp2.setAutoDraw(True)
        
        # if textIntroExp2 is active this frame...
        if textIntroExp2.status == STARTED:
            # update params
            pass
        
        # *keyIntroExp2* updates
        waitOnFlip = False
        
        # if keyIntroExp2 is starting this frame...
        if keyIntroExp2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            keyIntroExp2.frameNStart = frameN  # exact frame index
            keyIntroExp2.tStart = t  # local t and not account for scr refresh
            keyIntroExp2.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(keyIntroExp2, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'keyIntroExp2.started')
            # update status
            keyIntroExp2.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(keyIntroExp2.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(keyIntroExp2.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if keyIntroExp2.status == STARTED and not waitOnFlip:
            theseKeys = keyIntroExp2.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _keyIntroExp2_allKeys.extend(theseKeys)
            if len(_keyIntroExp2_allKeys):
                keyIntroExp2.keys = _keyIntroExp2_allKeys[-1].name  # just the last key pressed
                keyIntroExp2.rt = _keyIntroExp2_allKeys[-1].rt
                keyIntroExp2.duration = _keyIntroExp2_allKeys[-1].duration
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
        for thisComponent in introExp2Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "introExp2" ---
    for thisComponent in introExp2Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    thisExp.addData('introExp2.stopped', globalClock.getTime())
    # check responses
    if keyIntroExp2.keys in ['', [], None]:  # No response was made
        keyIntroExp2.keys = None
    thisExp.addData('keyIntroExp2.keys',keyIntroExp2.keys)
    if keyIntroExp2.keys != None:  # we had a response
        thisExp.addData('keyIntroExp2.rt', keyIntroExp2.rt)
        thisExp.addData('keyIntroExp2.duration', keyIntroExp2.duration)
    thisExp.nextEntry()
    # the Routine "introExp2" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # set up handler to look after randomisation of conditions etc
    trials = data.TrialHandler(nReps=N_stim, method='sequential', 
        extraInfo=expInfo, originPath=-1,
        trialList=[None],
        seed=None, name='trials')
    thisExp.addLoop(trials)  # add the loop to the experiment
    thisTrial = trials.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
    if thisTrial != None:
        for paramName in thisTrial:
            globals()[paramName] = thisTrial[paramName]
    
    for thisTrial in trials:
        currentLoop = trials
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
        # abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
        if thisTrial != None:
            for paramName in thisTrial:
                globals()[paramName] = thisTrial[paramName]
        
        # --- Prepare to start Routine "fixationCross_train1" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('fixationCross_train1.started', globalClock.getTime())
        keySkipS.keys = []
        keySkipS.rt = []
        _keySkipS_allKeys = []
        # keep track of which components have finished
        fixationCross_train1Components = [fixationCross0, keySkipS]
        for thisComponent in fixationCross_train1Components:
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
        
        # --- Run Routine "fixationCross_train1" ---
        routineForceEnded = not continueRoutine
        while continueRoutine and routineTimer.getTime() < 1.0:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *fixationCross0* updates
            
            # if fixationCross0 is starting this frame...
            if fixationCross0.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                fixationCross0.frameNStart = frameN  # exact frame index
                fixationCross0.tStart = t  # local t and not account for scr refresh
                fixationCross0.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(fixationCross0, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'fixationCross0.started')
                # update status
                fixationCross0.status = STARTED
                fixationCross0.setAutoDraw(True)
            
            # if fixationCross0 is active this frame...
            if fixationCross0.status == STARTED:
                # update params
                pass
            
            # if fixationCross0 is stopping this frame...
            if fixationCross0.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > fixationCross0.tStartRefresh + 1.0-frameTolerance:
                    # keep track of stop time/frame for later
                    fixationCross0.tStop = t  # not accounting for scr refresh
                    fixationCross0.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'fixationCross0.stopped')
                    # update status
                    fixationCross0.status = FINISHED
                    fixationCross0.setAutoDraw(False)
            
            # *keySkipS* updates
            waitOnFlip = False
            
            # if keySkipS is starting this frame...
            if keySkipS.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                keySkipS.frameNStart = frameN  # exact frame index
                keySkipS.tStart = t  # local t and not account for scr refresh
                keySkipS.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(keySkipS, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'keySkipS.started')
                # update status
                keySkipS.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(keySkipS.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(keySkipS.clearEvents, eventType='keyboard')  # clear events on next screen flip
            
            # if keySkipS is stopping this frame...
            if keySkipS.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > keySkipS.tStartRefresh + 1-frameTolerance:
                    # keep track of stop time/frame for later
                    keySkipS.tStop = t  # not accounting for scr refresh
                    keySkipS.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'keySkipS.stopped')
                    # update status
                    keySkipS.status = FINISHED
                    keySkipS.status = FINISHED
            if keySkipS.status == STARTED and not waitOnFlip:
                theseKeys = keySkipS.getKeys(keyList=['s'], ignoreKeys=["escape"], waitRelease=False)
                _keySkipS_allKeys.extend(theseKeys)
                if len(_keySkipS_allKeys):
                    keySkipS.keys = _keySkipS_allKeys[-1].name  # just the last key pressed
                    keySkipS.rt = _keySkipS_allKeys[-1].rt
                    keySkipS.duration = _keySkipS_allKeys[-1].duration
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
            for thisComponent in fixationCross_train1Components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "fixationCross_train1" ---
        for thisComponent in fixationCross_train1Components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('fixationCross_train1.stopped', globalClock.getTime())
        # check responses
        if keySkipS.keys in ['', [], None]:  # No response was made
            keySkipS.keys = None
        trials.addData('keySkipS.keys',keySkipS.keys)
        if keySkipS.keys != None:  # we had a response
            trials.addData('keySkipS.rt', keySkipS.rt)
            trials.addData('keySkipS.duration', keySkipS.duration)
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if routineForceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-1.000000)
        
        # --- Prepare to start Routine "stimVid_train1" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('stimVid_train1.started', globalClock.getTime())
        stimVid_train.setMovie(stimDirList[counterStim])
        keySkipS_2.keys = []
        keySkipS_2.rt = []
        _keySkipS_2_allKeys = []
        # keep track of which components have finished
        stimVid_train1Components = [stimVid_train, keySkipS_2]
        for thisComponent in stimVid_train1Components:
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
        
        # --- Run Routine "stimVid_train1" ---
        routineForceEnded = not continueRoutine
        while continueRoutine:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *stimVid_train* updates
            
            # if stimVid_train is starting this frame...
            if stimVid_train.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                stimVid_train.frameNStart = frameN  # exact frame index
                stimVid_train.tStart = t  # local t and not account for scr refresh
                stimVid_train.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(stimVid_train, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'stimVid_train.started')
                # update status
                stimVid_train.status = STARTED
                stimVid_train.setAutoDraw(True)
                stimVid_train.play()
            if stimVid_train.isFinished:  # force-end the Routine
                continueRoutine = False
            
            # *keySkipS_2* updates
            waitOnFlip = False
            
            # if keySkipS_2 is starting this frame...
            if keySkipS_2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                keySkipS_2.frameNStart = frameN  # exact frame index
                keySkipS_2.tStart = t  # local t and not account for scr refresh
                keySkipS_2.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(keySkipS_2, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'keySkipS_2.started')
                # update status
                keySkipS_2.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(keySkipS_2.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(keySkipS_2.clearEvents, eventType='keyboard')  # clear events on next screen flip
            
            # if keySkipS_2 is stopping this frame...
            if keySkipS_2.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > keySkipS_2.tStartRefresh + 4.5-frameTolerance:
                    # keep track of stop time/frame for later
                    keySkipS_2.tStop = t  # not accounting for scr refresh
                    keySkipS_2.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'keySkipS_2.stopped')
                    # update status
                    keySkipS_2.status = FINISHED
                    keySkipS_2.status = FINISHED
            if keySkipS_2.status == STARTED and not waitOnFlip:
                theseKeys = keySkipS_2.getKeys(keyList=['s'], ignoreKeys=["escape"], waitRelease=False)
                _keySkipS_2_allKeys.extend(theseKeys)
                if len(_keySkipS_2_allKeys):
                    keySkipS_2.keys = _keySkipS_2_allKeys[-1].name  # just the last key pressed
                    keySkipS_2.rt = _keySkipS_2_allKeys[-1].rt
                    keySkipS_2.duration = _keySkipS_2_allKeys[-1].duration
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
            for thisComponent in stimVid_train1Components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "stimVid_train1" ---
        for thisComponent in stimVid_train1Components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('stimVid_train1.stopped', globalClock.getTime())
        stimVid_train.stop()  # ensure movie has stopped at end of Routine
        # Run 'End Routine' code from codeStimVid
        counterStim += 1
        # check responses
        if keySkipS_2.keys in ['', [], None]:  # No response was made
            keySkipS_2.keys = None
        trials.addData('keySkipS_2.keys',keySkipS_2.keys)
        if keySkipS_2.keys != None:  # we had a response
            trials.addData('keySkipS_2.rt', keySkipS_2.rt)
            trials.addData('keySkipS_2.duration', keySkipS_2.duration)
        # the Routine "stimVid_train1" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        
        # --- Prepare to start Routine "fixationCross_train1" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('fixationCross_train1.started', globalClock.getTime())
        keySkipS.keys = []
        keySkipS.rt = []
        _keySkipS_allKeys = []
        # keep track of which components have finished
        fixationCross_train1Components = [fixationCross0, keySkipS]
        for thisComponent in fixationCross_train1Components:
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
        
        # --- Run Routine "fixationCross_train1" ---
        routineForceEnded = not continueRoutine
        while continueRoutine and routineTimer.getTime() < 1.0:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *fixationCross0* updates
            
            # if fixationCross0 is starting this frame...
            if fixationCross0.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                fixationCross0.frameNStart = frameN  # exact frame index
                fixationCross0.tStart = t  # local t and not account for scr refresh
                fixationCross0.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(fixationCross0, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'fixationCross0.started')
                # update status
                fixationCross0.status = STARTED
                fixationCross0.setAutoDraw(True)
            
            # if fixationCross0 is active this frame...
            if fixationCross0.status == STARTED:
                # update params
                pass
            
            # if fixationCross0 is stopping this frame...
            if fixationCross0.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > fixationCross0.tStartRefresh + 1.0-frameTolerance:
                    # keep track of stop time/frame for later
                    fixationCross0.tStop = t  # not accounting for scr refresh
                    fixationCross0.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'fixationCross0.stopped')
                    # update status
                    fixationCross0.status = FINISHED
                    fixationCross0.setAutoDraw(False)
            
            # *keySkipS* updates
            waitOnFlip = False
            
            # if keySkipS is starting this frame...
            if keySkipS.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                keySkipS.frameNStart = frameN  # exact frame index
                keySkipS.tStart = t  # local t and not account for scr refresh
                keySkipS.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(keySkipS, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'keySkipS.started')
                # update status
                keySkipS.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(keySkipS.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(keySkipS.clearEvents, eventType='keyboard')  # clear events on next screen flip
            
            # if keySkipS is stopping this frame...
            if keySkipS.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > keySkipS.tStartRefresh + 1-frameTolerance:
                    # keep track of stop time/frame for later
                    keySkipS.tStop = t  # not accounting for scr refresh
                    keySkipS.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'keySkipS.stopped')
                    # update status
                    keySkipS.status = FINISHED
                    keySkipS.status = FINISHED
            if keySkipS.status == STARTED and not waitOnFlip:
                theseKeys = keySkipS.getKeys(keyList=['s'], ignoreKeys=["escape"], waitRelease=False)
                _keySkipS_allKeys.extend(theseKeys)
                if len(_keySkipS_allKeys):
                    keySkipS.keys = _keySkipS_allKeys[-1].name  # just the last key pressed
                    keySkipS.rt = _keySkipS_allKeys[-1].rt
                    keySkipS.duration = _keySkipS_allKeys[-1].duration
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
            for thisComponent in fixationCross_train1Components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "fixationCross_train1" ---
        for thisComponent in fixationCross_train1Components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('fixationCross_train1.stopped', globalClock.getTime())
        # check responses
        if keySkipS.keys in ['', [], None]:  # No response was made
            keySkipS.keys = None
        trials.addData('keySkipS.keys',keySkipS.keys)
        if keySkipS.keys != None:  # we had a response
            trials.addData('keySkipS.rt', keySkipS.rt)
            trials.addData('keySkipS.duration', keySkipS.duration)
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if routineForceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-1.000000)
        
        # --- Prepare to start Routine "executionPhase" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('executionPhase.started', globalClock.getTime())
        # keep track of which components have finished
        executionPhaseComponents = [executionCircle, text]
        for thisComponent in executionPhaseComponents:
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
        
        # --- Run Routine "executionPhase" ---
        routineForceEnded = not continueRoutine
        while continueRoutine and routineTimer.getTime() < 4.0:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *executionCircle* updates
            
            # if executionCircle is starting this frame...
            if executionCircle.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                executionCircle.frameNStart = frameN  # exact frame index
                executionCircle.tStart = t  # local t and not account for scr refresh
                executionCircle.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(executionCircle, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'executionCircle.started')
                # update status
                executionCircle.status = STARTED
                executionCircle.setAutoDraw(True)
            
            # if executionCircle is active this frame...
            if executionCircle.status == STARTED:
                # update params
                pass
            
            # if executionCircle is stopping this frame...
            if executionCircle.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > executionCircle.tStartRefresh + 4-frameTolerance:
                    # keep track of stop time/frame for later
                    executionCircle.tStop = t  # not accounting for scr refresh
                    executionCircle.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'executionCircle.stopped')
                    # update status
                    executionCircle.status = FINISHED
                    executionCircle.setAutoDraw(False)
            
            # *text* updates
            
            # if text is starting this frame...
            if text.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                text.frameNStart = frameN  # exact frame index
                text.tStart = t  # local t and not account for scr refresh
                text.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(text, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'text.started')
                # update status
                text.status = STARTED
                text.setAutoDraw(True)
            
            # if text is active this frame...
            if text.status == STARTED:
                # update params
                pass
            
            # if text is stopping this frame...
            if text.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > text.tStartRefresh + 4-frameTolerance:
                    # keep track of stop time/frame for later
                    text.tStop = t  # not accounting for scr refresh
                    text.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'text.stopped')
                    # update status
                    text.status = FINISHED
                    text.setAutoDraw(False)
            
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
            for thisComponent in executionPhaseComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "executionPhase" ---
        for thisComponent in executionPhaseComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('executionPhase.stopped', globalClock.getTime())
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if routineForceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-4.000000)
        
        # --- Prepare to start Routine "ITI_train1" ---
        continueRoutine = True
        # update component parameters for each repeat
        thisExp.addData('ITI_train1.started', globalClock.getTime())
        keySkipS_3.keys = []
        keySkipS_3.rt = []
        _keySkipS_3_allKeys = []
        # keep track of which components have finished
        ITI_train1Components = [ITI_train, keySkipS_3]
        for thisComponent in ITI_train1Components:
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
        
        # --- Run Routine "ITI_train1" ---
        routineForceEnded = not continueRoutine
        while continueRoutine and routineTimer.getTime() < 3.0:
            # get current time
            t = routineTimer.getTime()
            tThisFlip = win.getFutureFlipTime(clock=routineTimer)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *ITI_train* updates
            
            # if ITI_train is starting this frame...
            if ITI_train.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                ITI_train.frameNStart = frameN  # exact frame index
                ITI_train.tStart = t  # local t and not account for scr refresh
                ITI_train.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(ITI_train, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'ITI_train.started')
                # update status
                ITI_train.status = STARTED
                ITI_train.setAutoDraw(True)
            
            # if ITI_train is active this frame...
            if ITI_train.status == STARTED:
                # update params
                pass
            
            # if ITI_train is stopping this frame...
            if ITI_train.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > ITI_train.tStartRefresh + 3-frameTolerance:
                    # keep track of stop time/frame for later
                    ITI_train.tStop = t  # not accounting for scr refresh
                    ITI_train.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'ITI_train.stopped')
                    # update status
                    ITI_train.status = FINISHED
                    ITI_train.setAutoDraw(False)
            
            # *keySkipS_3* updates
            waitOnFlip = False
            
            # if keySkipS_3 is starting this frame...
            if keySkipS_3.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                keySkipS_3.frameNStart = frameN  # exact frame index
                keySkipS_3.tStart = t  # local t and not account for scr refresh
                keySkipS_3.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(keySkipS_3, 'tStartRefresh')  # time at next scr refresh
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'keySkipS_3.started')
                # update status
                keySkipS_3.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(keySkipS_3.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(keySkipS_3.clearEvents, eventType='keyboard')  # clear events on next screen flip
            
            # if keySkipS_3 is stopping this frame...
            if keySkipS_3.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > keySkipS_3.tStartRefresh + 3-frameTolerance:
                    # keep track of stop time/frame for later
                    keySkipS_3.tStop = t  # not accounting for scr refresh
                    keySkipS_3.frameNStop = frameN  # exact frame index
                    # add timestamp to datafile
                    thisExp.timestampOnFlip(win, 'keySkipS_3.stopped')
                    # update status
                    keySkipS_3.status = FINISHED
                    keySkipS_3.status = FINISHED
            if keySkipS_3.status == STARTED and not waitOnFlip:
                theseKeys = keySkipS_3.getKeys(keyList=['s'], ignoreKeys=["escape"], waitRelease=False)
                _keySkipS_3_allKeys.extend(theseKeys)
                if len(_keySkipS_3_allKeys):
                    keySkipS_3.keys = _keySkipS_3_allKeys[-1].name  # just the last key pressed
                    keySkipS_3.rt = _keySkipS_3_allKeys[-1].rt
                    keySkipS_3.duration = _keySkipS_3_allKeys[-1].duration
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
            for thisComponent in ITI_train1Components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # --- Ending Routine "ITI_train1" ---
        for thisComponent in ITI_train1Components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        thisExp.addData('ITI_train1.stopped', globalClock.getTime())
        # check responses
        if keySkipS_3.keys in ['', [], None]:  # No response was made
            keySkipS_3.keys = None
        trials.addData('keySkipS_3.keys',keySkipS_3.keys)
        if keySkipS_3.keys != None:  # we had a response
            trials.addData('keySkipS_3.rt', keySkipS_3.rt)
            trials.addData('keySkipS_3.duration', keySkipS_3.duration)
        # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
        if routineForceEnded:
            routineTimer.reset()
        else:
            routineTimer.addTime(-3.000000)
    # completed N_stim repeats of 'trials'
    
    
    # --- Prepare to start Routine "endTrain1" ---
    continueRoutine = True
    # update component parameters for each repeat
    thisExp.addData('endTrain1.started', globalClock.getTime())
    keyEndTrain1.keys = []
    keyEndTrain1.rt = []
    _keyEndTrain1_allKeys = []
    # keep track of which components have finished
    endTrain1Components = [textEndTrain1, keyEndTrain1]
    for thisComponent in endTrain1Components:
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
    
    # --- Run Routine "endTrain1" ---
    routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *textEndTrain1* updates
        
        # if textEndTrain1 is starting this frame...
        if textEndTrain1.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            textEndTrain1.frameNStart = frameN  # exact frame index
            textEndTrain1.tStart = t  # local t and not account for scr refresh
            textEndTrain1.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(textEndTrain1, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'textEndTrain1.started')
            # update status
            textEndTrain1.status = STARTED
            textEndTrain1.setAutoDraw(True)
        
        # if textEndTrain1 is active this frame...
        if textEndTrain1.status == STARTED:
            # update params
            pass
        
        # *keyEndTrain1* updates
        waitOnFlip = False
        
        # if keyEndTrain1 is starting this frame...
        if keyEndTrain1.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            keyEndTrain1.frameNStart = frameN  # exact frame index
            keyEndTrain1.tStart = t  # local t and not account for scr refresh
            keyEndTrain1.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(keyEndTrain1, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'keyEndTrain1.started')
            # update status
            keyEndTrain1.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(keyEndTrain1.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(keyEndTrain1.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if keyEndTrain1.status == STARTED and not waitOnFlip:
            theseKeys = keyEndTrain1.getKeys(keyList=['space'], ignoreKeys=["escape"], waitRelease=False)
            _keyEndTrain1_allKeys.extend(theseKeys)
            if len(_keyEndTrain1_allKeys):
                keyEndTrain1.keys = _keyEndTrain1_allKeys[-1].name  # just the last key pressed
                keyEndTrain1.rt = _keyEndTrain1_allKeys[-1].rt
                keyEndTrain1.duration = _keyEndTrain1_allKeys[-1].duration
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
        for thisComponent in endTrain1Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "endTrain1" ---
    for thisComponent in endTrain1Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    thisExp.addData('endTrain1.stopped', globalClock.getTime())
    # check responses
    if keyEndTrain1.keys in ['', [], None]:  # No response was made
        keyEndTrain1.keys = None
    thisExp.addData('keyEndTrain1.keys',keyEndTrain1.keys)
    if keyEndTrain1.keys != None:  # we had a response
        thisExp.addData('keyEndTrain1.rt', keyEndTrain1.rt)
        thisExp.addData('keyEndTrain1.duration', keyEndTrain1.duration)
    thisExp.nextEntry()
    # the Routine "endTrain1" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
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
