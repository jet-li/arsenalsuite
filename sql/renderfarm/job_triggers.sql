
CREATE OR REPLACE FUNCTION Job_Update() RETURNS trigger AS $$
DECLARE
	stat RECORD;
BEGIN
	-- Set Job.taskscount and Job.tasksunassigned
	IF NEW.status IN ('verify','verify-suspended') THEN
		PERFORM update_job_task_counts(NEW.keyjob);
	END IF;

	IF (NEW.fkeyjobstat IS NOT NULL) THEN
		IF (NEW.status='started' AND OLD.status='ready') THEN
			UPDATE jobstat SET started=NOW() WHERE keyjobstat=NEW.fkeyjobstat AND started IS NULL;
		END IF;
		IF (NEW.status='ready' AND OLD.status='done') THEN
			SELECT INTO stat * from jobstat where keyjobstat=NEW.fkeyjobstat;
			INSERT INTO jobstat (fkeyelement, fkeyproject, taskCount, fkeyusr, started, pass) VALUES (stat.fkeyelement, stat.fkeyproject, stat.taskCount, stat.fkeyusr, NOW(), stat.pass);
			SELECT INTO NEW.fkeyjobstat currval('jobstat_keyjobstat_seq');
		END IF;
		IF (NEW.status IN ('done','deleted') AND OLD.status IN ('ready','started') ) THEN
			UPDATE jobstat
			SET
				ended=NOW(),
				errorcount=iq.errorcount,
				totaltasktime=iq.totaltasktime, mintasktime=iq.mintasktime, maxtasktime=iq.maxtasktime, avgtasktime=iq.avgtasktime,
				totalloadtime=iq.totalloadtime, minloadtime=iq.minloadtime, maxloadtime=iq.maxloadtime, avgloadtime=iq.avgloadtime,
				totalerrortime=iq.totalerrortime, minerrortime=iq.minerrortime, maxerrortime=iq.maxerrortime, avgerrortime=iq.avgerrortime,
				totalcopytime=iq.totalcopytime, mincopytime=iq.mincopytime, maxcopytime=iq.maxcopytime, avgcopytime=iq.avgcopytime
			FROM (select * FROM Job_GatherStats(NEW.keyjob)) as iq
			WHERE keyjobstat=NEW.fkeyjobstat;
			UPDATE jobstat
			SET
				taskcount=iq.taskscount,
				taskscompleted=iq.tasksdone
			FROM (select jobstatus.taskscount, jobstatus.tasksdone FROM jobstatus WHERE jobstatus.fkeyjob=NEW.keyjob) as iq
			WHERE keyjobstat=NEW.fkeyjobstat;
		END IF;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS Job_Update ON job;
DROP TRIGGER IF EXISTS JobBatch_Update ON jobbatch;
DROP TRIGGER IF EXISTS JobMax7_Update ON jobmax7;
DROP TRIGGER IF EXISTS JobMax8_Update ON jobmax8;
DROP TRIGGER IF EXISTS JobMax9_Update ON jobmax9;
DROP TRIGGER IF EXISTS JobMax10_Update ON jobmax10;
DROP TRIGGER IF EXISTS JobMax2009_Update ON jobmax2009;
DROP TRIGGER IF EXISTS JobMaxScript_Update ON jobmaxscript;
DROP TRIGGER IF EXISTS JobXSI_Update ON jobxsi;
DROP TRIGGER IF EXISTS JobXSIScript_Update on jobxsiscript;
DROP TRIGGER IF EXISTS JobCinema4d_Update ON jobcinema4d;
DROP TRIGGER IF EXISTS JobAfterEffects_Update ON jobaftereffects;
DROP TRIGGER IF EXISTS JobAfterEffects7_Update ON jobaftereffects7;
DROP TRIGGER IF EXISTS JobAfterEffects8_Update ON jobaftereffects8;
DROP TRIGGER IF EXISTS JobMaya7_Update ON jobmaya7;
DROP TRIGGER IF EXISTS JobMaya85_Update ON jobmaya85;
DROP TRIGGER IF EXISTS JobMaya2008_Update ON jobmaya2008;
DROP TRIGGER IF EXISTS JobMaya2009_Update ON jobmaya2009;
DROP TRIGGER IF EXISTS JobMaya2011_Update ON jobmaya2011;
DROP TRIGGER IF EXISTS JobMentalRay85_Update ON jobmentalray85;
DROP TRIGGER IF EXISTS JobMentalRay2009_Update ON jobmentalray2009;
DROP TRIGGER IF EXISTS JobMentalRay2011_Update ON jobmentalray2011;
DROP TRIGGER IF EXISTS JobShake_Update ON jobshake;
DROP TRIGGER IF EXISTS JobSync_Update ON jobsync;
DROP TRIGGER IF EXISTS JobFusion_Update ON jobfusion;
DROP TRIGGER IF EXISTS JobFusionVideoMaker_Update ON jobfusionvideomaker;
DROP TRIGGER IF EXISTS JobNuke51_Update ON jobnuke51;
DROP TRIGGER IF EXISTS JobNuke52_Update ON jobnuke52;
DROP TRIGGER IF EXISTS Job3Delight_Update ON job3delight;
DROP TRIGGER IF EXISTS JobRealFlow_Update ON jobrealflow;
DROP TRIGGER IF EXISTS JobHoudiniSim10_Update ON jobhoudinisim10;
DROP TRIGGER IF EXISTS JobMantra100_Update ON jobmantra100;
DROP TRIGGER IF EXISTS JobNaiad_Update ON jobnaiad;

CREATE TRIGGER Job_Update BEFORE UPDATE ON job FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobBatch_Update BEFORE UPDATE ON jobbatch FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMax7_Update BEFORE UPDATE ON jobmax7 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMax8_Update BEFORE UPDATE ON jobmax8 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMax9_Update BEFORE UPDATE ON JobMax9 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMax10_Update BEFORE UPDATE ON JobMax10 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMax2009_Update BEFORE UPDATE ON JobMax2009 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMaxScript_Update BEFORE UPDATE ON JobMaxScript FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobXSI_Update BEFORE UPDATE ON jobxsi FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobXSIScript_Update BEFORE UPDATE ON jobxsiscript FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobCinema4d_Update BEFORE UPDATE ON JobCinema4d FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobAfterEffects_Update BEFORE UPDATE ON JobAfterEffects FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobAfterEffects7_Update BEFORE UPDATE ON JobAfterEffects7 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobAfterEffects8_Update BEFORE UPDATE ON JobAfterEffects8 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMaya7_Update BEFORE UPDATE ON JobMaya7 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMaya85_Update BEFORE UPDATE ON JobMaya85 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMaya2008_Update BEFORE UPDATE ON JobMaya2008 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMaya2009_Update BEFORE UPDATE ON JobMaya2009 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMaya2011_Update BEFORE UPDATE ON JobMaya2011 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMentalRay85_Update BEFORE UPDATE ON JobMentalRay85 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMentalRay2009_Update BEFORE UPDATE ON JobMentalRay2009 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMentalRay2011_Update BEFORE UPDATE ON JobMentalRay2011 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobShake_Update BEFORE UPDATE ON JobShake FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobSync_Update BEFORE UPDATE ON JobSync FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobFusion_Update BEFORE UPDATE ON JobFusion FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobFusionVideoMaker_Update BEFORE UPDATE ON JobFusionVideoMaker FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobNuke51_Update BEFORE UPDATE ON JobNuke51 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobNuke52_Update BEFORE UPDATE ON JobNuke52 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobMantra100_Update BEFORE UPDATE ON JobMantra100 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER Job3Delight_Update BEFORE UPDATE ON Job3Delight FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobRealFlow_Update BEFORE UPDATE ON JobRealFlow FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobHoudiniSim10_Update BEFORE UPDATE ON JobHoudiniSim10 FOR EACH ROW EXECUTE PROCEDURE Job_Update();
CREATE TRIGGER JobNaiad_Update BEFORE UPDATE ON JobNaiad FOR EACH ROW EXECUTE PROCEDURE Job_Update();

-- INSERT triggers
CREATE OR REPLACE FUNCTION Job_Insert()
  RETURNS "trigger" AS
$BODY$
BEGIN
	INSERT INTO jobstat (name,fkeyelement,fkeyproject,fkeyusr) VALUES (NEW.job, NEW.fkeyelement, NEW.fkeyproject, NEW.fkeyusr) RETURNING keyjobstat INTO NEW.fkeyjobstat;
	INSERT INTO jobstatus (fkeyjob) VALUES (NEW.keyjob);
RETURN NEW;
END;
$BODY$
  LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS Job_Insert ON job;
DROP TRIGGER IF EXISTS JobBatch_Insert ON jobbatch;
DROP TRIGGER IF EXISTS JobMax7_Insert ON jobmax7;
DROP TRIGGER IF EXISTS JobMax8_Insert ON jobmax8;
DROP TRIGGER IF EXISTS JobMax9_Insert ON jobmax9;
DROP TRIGGER IF EXISTS JobMax10_Insert ON jobmax10;
DROP TRIGGER IF EXISTS JobMax2009_Insert ON jobmax2009;
DROP TRIGGER IF EXISTS JobMaxScript_Insert ON jobmaxscript;
DROP TRIGGER IF EXISTS JobXSI_Insert ON jobxsi;
DROP TRIGGER IF EXISTS JobXSIScript_Insert ON jobxsiscript;
DROP TRIGGER IF EXISTS JobCinema4d_Insert ON jobcinema4d;
DROP TRIGGER IF EXISTS JobAfterEffects_Insert ON jobaftereffects;
DROP TRIGGER IF EXISTS JobAfterEffects7_Insert ON jobaftereffects7;
DROP TRIGGER IF EXISTS JobAfterEffects8_Insert ON jobaftereffects8;
DROP TRIGGER IF EXISTS JobMaya7_Insert ON jobmaya7;
DROP TRIGGER IF EXISTS JobMaya85_Insert ON jobmaya85;
DROP TRIGGER IF EXISTS JobMaya2008_Insert ON jobmaya2008;
DROP TRIGGER IF EXISTS JobMaya2009_Insert ON jobmaya2009;
DROP TRIGGER IF EXISTS JobMaya2011_Insert ON jobmaya2011;
DROP TRIGGER IF EXISTS JobMentalRay85_Insert ON jobmentalray85;
DROP TRIGGER IF EXISTS JobMentalRay2009_Insert ON jobmentalray2009;
DROP TRIGGER IF EXISTS JobMentalRay2011_Insert ON jobmentalray2011;
DROP TRIGGER IF EXISTS JobShake_Insert ON jobshake;
DROP TRIGGER IF EXISTS JobSync_Insert ON jobsync;
DROP TRIGGER IF EXISTS JobFusion_Insert ON jobfusion;
DROP TRIGGER IF EXISTS JobFusionVideoMaker_Insert ON jobfusionvideomaker;
DROP TRIGGER IF EXISTS JobNuke51_Insert ON jobnuke51;
DROP TRIGGER IF EXISTS JobNuke52_Insert ON jobnuke52;
DROP TRIGGER IF EXISTS JobMantra100_Insert ON jobmantra100;
DROP TRIGGER IF EXISTS Job3Delight_Insert ON job3delight;
DROP TRIGGER IF EXISTS JobRealFlow_Insert ON jobrealflow;
DROP TRIGGER IF EXISTS JobHoudiniSim10_Insert ON jobhoudinisim10;
DROP TRIGGER IF EXISTS JobNaiad_Insert ON jobnaiad;

CREATE TRIGGER Job_Insert AFTER INSERT ON job FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobBatch_Insert AFTER INSERT ON jobbatch FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMax7_Insert AFTER INSERT ON jobmax7 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMax8_Insert AFTER INSERT ON jobmax8 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMax9_Insert AFTER INSERT ON jobmax9 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMax10_Insert AFTER INSERT ON jobmax10 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMax2009_Insert AFTER INSERT ON jobmax2009 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMaxScript_Insert AFTER INSERT ON jobmaxscript FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobXSI_Insert AFTER INSERT ON jobxsi FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobXSIScript_Insert AFTER INSERT ON jobxsiscript FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobCinema4d_Insert AFTER INSERT ON JobCinema4d FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobAfterEffects_Insert AFTER INSERT ON JobAfterEffects FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobAfterEffects7_Insert AFTER INSERT ON JobAfterEffects7 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobAfterEffects8_Insert AFTER INSERT ON JobAfterEffects8 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMaya7_Insert AFTER INSERT ON JobMaya7 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMaya85_Insert AFTER INSERT ON JobMaya85 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMaya2008_Insert AFTER INSERT ON JobMaya2008 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMaya2009_Insert AFTER INSERT ON JobMaya2009 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMaya2011_Insert AFTER INSERT ON JobMaya2011 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMentalRay85_Insert AFTER INSERT ON JobMentalRay85 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMentalRay2009_Insert AFTER INSERT ON JobMentalRay2009 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMentalRay2011_Insert AFTER INSERT ON JobMentalRay2011 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobShake_Insert AFTER INSERT ON JobShake FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobSync_Insert AFTER INSERT ON JobSync FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobFusion_Insert AFTER INSERT ON JobFusion FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobFusionVideoMaker_Insert AFTER INSERT ON JobFusionVideoMaker FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobNuke51_Insert AFTER INSERT ON JobNuke51 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobNuke52_Insert AFTER INSERT ON JobNuke52 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobMantra100_Insert AFTER INSERT ON JobMantra100 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER Job3Delight_Insert AFTER INSERT ON Job3Delight FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobRealFlow_Insert AFTER INSERT ON JobRealFlow FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobHoudiniSim10_Insert AFTER INSERT ON JobHoudiniSim10 FOR EACH ROW EXECUTE PROCEDURE Job_Insert();
CREATE TRIGGER JobNaiad_Insert AFTER INSERT ON JobNaiad FOR EACH ROW EXECUTE PROCEDURE Job_Insert();

