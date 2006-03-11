/*
 * Copyright 2004-2006 the original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.compass.core.lucene.engine.optimizer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.lucene.index.LuceneSubIndexInfo;
import org.compass.core.config.CompassSettings;
import org.compass.core.engine.SearchEngineException;
import org.compass.core.engine.SearchEngineFactory;
import org.compass.core.lucene.LuceneEnvironment;
import org.compass.core.lucene.engine.LuceneSearchEngineFactory;
import org.compass.core.util.backport.java.util.concurrent.Executors;
import org.compass.core.util.backport.java.util.concurrent.ScheduledExecutorService;
import org.compass.core.util.backport.java.util.concurrent.TimeUnit;
import org.compass.core.util.concurrent.SingleThreadThreadFactory;

/**
 * @author kimchy
 */
public class ScheduledLuceneSearchEngineOptimizer implements LuceneSearchEngineOptimizer {

    final static private Log log = LogFactory.getLog(ScheduledLuceneSearchEngineOptimizer.class);

    private LuceneSearchEngineOptimizer optimizer;

    private ScheduledExecutorService scheduledExecutorService;

    public ScheduledLuceneSearchEngineOptimizer(LuceneSearchEngineOptimizer optimizer) {
        this.optimizer = optimizer;
    }

    public LuceneSearchEngineFactory getSearchEngineFactory() {
        return this.optimizer.getSearchEngineFactory();
    }

    public void setSearchEngineFactory(LuceneSearchEngineFactory searchEngineFactory) {
        this.optimizer.setSearchEngineFactory(searchEngineFactory);
    }

    public boolean needOptimization() throws SearchEngineException {
        return this.optimizer.needOptimization();
    }

    public void optimize() throws SearchEngineException {
        this.optimizer.optimize();
    }

    public boolean needOptimizing(String subIndex) throws SearchEngineException {
        return this.optimizer.needOptimizing(subIndex);
    }

    public boolean needOptimizing(String subIndex, LuceneSubIndexInfo segmentInfos) throws SearchEngineException {
        return this.optimizer.needOptimizing(subIndex, segmentInfos);
    }

    public void optimize(String subIndex, LuceneSubIndexInfo segmentInfos) throws SearchEngineException {
        this.optimizer.optimize(subIndex, segmentInfos);
    }

    public synchronized void start() throws SearchEngineException {
        if (isRunning()) {
            throw new IllegalStateException("Optimizer is already running");
        }

        this.optimizer.start();

        CompassSettings settings = getSearchEngineFactory().getSettings();
        boolean daemon = settings.getSettingAsBoolean(LuceneEnvironment.Optimizer.SCHEDULE_DEAMON, true);
        long period = (long) (settings.getSettingAsFloat(LuceneEnvironment.Optimizer.SCHEDULE_PERIOD, 10) * 1000);
        if (log.isInfoEnabled()) {
            log.info("Starting scheduled optimizer [" + optimizer.getClass() + "] with period [" + period
                    + "ms] daemon [" + daemon + "]");
        }
        scheduledExecutorService = Executors.newSingleThreadScheduledExecutor(new SingleThreadThreadFactory("Compass Scheduled Optimizer", daemon));
        ScheduledOptimizeRunnable scheduledOptimizeRunnable =
                new ScheduledOptimizeRunnable(getOptimizerTemplate());
        scheduledExecutorService.scheduleWithFixedDelay(scheduledOptimizeRunnable, period, period, TimeUnit.MILLISECONDS);
    }

    public synchronized void stop() throws SearchEngineException {
        if (!isRunning()) {
            throw new IllegalStateException("Optimizer is not running");
        }
        if (log.isInfoEnabled()) {
            log.info("Stopping scheduled optimizer [" + optimizer.getClass() + "]");
        }
        getOptimizerTemplate().cancel();
        // TODO should we gracefully wait for it?
        scheduledExecutorService.shutdown();
        scheduledExecutorService = null;
        this.optimizer.stop();
    }

    public boolean isRunning() {
        return this.optimizer.isRunning();
    }

    public LuceneSearchEngineOptimizer getWrappedOptimizer() {
        return this.optimizer;
    }

    public boolean canBeScheduled() {
        return false;
    }

    public OptimizerTemplate getOptimizerTemplate() {
        return this.optimizer.getOptimizerTemplate();
    }

    private static class ScheduledOptimizeRunnable implements Runnable {

        private OptimizerTemplate optimizerTemplate;

        public ScheduledOptimizeRunnable(OptimizerTemplate optimizerTemplate) {
            this.optimizerTemplate = optimizerTemplate;
        }

        public void run() {
            if (log.isDebugEnabled()) {
                log.debug("Checking for index optimization");
            }
            try {
                optimizerTemplate.optimize();
            } catch (Exception e) {
                if (log.isDebugEnabled()) {
                    log.debug("Failed to optimize", e);
                }
            }
        }
    }
}
