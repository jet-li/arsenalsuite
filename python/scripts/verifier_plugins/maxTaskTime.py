
from PyQt4.QtCore import *
from PyQt4.QtSql import *
from blur.Stone import *
from blur.Classes import *

from verifier_plugin_factory import *

def doThis(job):
    print "maxTaskTime - checking %s" % job.name()

    if job.user().name() == "dan.bethell": return True
    if job.user().name() == "alexander.samsonov": return True

    if( job.jobType().name().contains("Mantra") ):
        job.setMaxTaskTime(2 * 60 * 60)
        job.setMaxQuietTime(1 * 60 * 60)
        job.setThreads(4)
        job.setAssignmentSlots(4)
        job.setMinMemory(4000000)
        job.setMaxMemory(8000000)
        job.setPacketType('iterative')
    if( job.jobType().name() == "3Delight" ):
        job.setPacketSize(1)
        job.setAutoAdaptSlots(0)
        if not job.priority() == 29:
            job.setPacketType('iterative')
        if (job.name().contains("BIGMEM")):
            job.setMaxTaskTime(4 * 60 * 60)
            job.setThreads(8)
            job.setAssignmentSlots(8)
            job.setMinMemory(16000000)
            job.setMaxMemory(20000000)
            print "maxTaskTime - BIGMEM render given more resources"
        else:
            job.setMaxTaskTime(4 * 60 * 60)
            job.setThreads(8)
            job.setAssignmentSlots(8)
            job.setMinMemory(6000000)
            job.setMaxMemory(16000000)

    if( job.jobType().name().contains( "Nuke" ) ):
        job.setMaxTaskTime(1800)
        job.setMinMemory(6000000)
        job.setMaxMemory(8000000)
    if( job.jobType().name().contains( "Naiad" ) ):
        job.setMinMemory(20000000)
        job.setMaxMemory(24000000)
    if( job.jobType().name().contains( "Batch" ) ):
        if (job.name().contains("_rib")):
            if (job.name().contains("BIGMEM")):
                job.setMinMemory(12000000)
                job.setMaxMemory(16000000)
            else:
                job.setMinMemory(6000000)
                job.setMaxMemory(8000000)

            job.setAssignmentSlots(1)
            job.setPacketSize(20)

    job.commit()
    return True

VerifierPluginFactory().registerPlugin("maxTaskTime", doThis)

