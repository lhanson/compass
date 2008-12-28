/*
 * Copyright 2004-2008 the original author or authors.
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

package org.compass.core.lucene.engine.transaction.support;

import java.util.ArrayList;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import org.apache.commons.logging.Log;
import org.compass.core.Resource;
import org.compass.core.engine.SearchEngineException;
import org.compass.core.lucene.engine.LuceneSearchEngine;
import org.compass.core.lucene.engine.LuceneSearchEngineHits;
import org.compass.core.lucene.engine.LuceneSearchEngineInternalSearch;
import org.compass.core.lucene.engine.LuceneSearchEngineQuery;
import org.compass.core.spi.InternalResource;
import org.compass.core.spi.ResourceKey;

/**
 * Base class support for async dirty operation processing.
 *
 * <p>Each dirty operation is added to a backlog for a specific thread to proces it (obtained from
 * {@link org.compass.core.executor.ExecutorManager}). A {@link org.compass.core.lucene.engine.transaction.support.AbstractConcurrentTransactionProcessor.Processor}
 * is assigned for each thread responsible for processing dirty operations.
 *
 * <p>Extedning classes should implement teh required operations and provide indication as to if search/read operations
 * should block until all dirty operations have been processed, and if concurrent operations are even allowed. In case
 * concurrent operations are not allowed, all dirty operations will be perfomed in a sync manner.
 *
 * <p>Different settings can control how the concurrent processing is perfomed. Settings names are based on
 * {@link #getName()} by using {@link #getSettingName(String)}.
 *
 * <p>The <code>concurrentOperations</code> setting can be used to disable concurrent dirty operations, or enable
 * them. This is only applies of the concurrentOperations parameter in the constructor is <code>true</code>.
 *
 * <p>The number of processor threads can be controlled using <code>concurrencyLevel</code> setting. It defaults to
 * 5 threads.
 *
 * <p>Operations are hashed to their respective processor thread for procesing. Hashing can be controlled to either
 * be perofmed based on <code>uid</code> or <code>subindex</code>. The default is <code>uid</code>.
 *
 * <p>The size of the backlog for each processor thread can also be controlled. If the backlog is full, user operations
 * will block until space becaomes available (by the respective processor processing the operations). The amount of time
 * the operation will block can be controlled using the <code>addTimeout</code> setting which defaults to 10 seconds.
 *
 * @author kimchy
 */
public abstract class AbstractConcurrentTransactionProcessor extends AbstractSearchTransactionProcessor {

    private final boolean waitForSearchOperations;

    private final boolean concurrentOperations;

    private final int concurrencyLevel;

    private Processor[] processors;

    private final ResourceHashing hashing;

    private final int backlog;

    private final long addTimeout;

    protected AbstractConcurrentTransactionProcessor(Log logger, LuceneSearchEngine searchEngine,
                                                     boolean waitForSearchOperations, boolean concurrentOperations) {
        super(logger, searchEngine);
        this.waitForSearchOperations = waitForSearchOperations;
        this.concurrentOperations = concurrentOperations && searchEngine.getSettings().getSettingAsBoolean(getSettingName("concurrentOperations"), true);
        this.concurrencyLevel = searchEngine.getSettings().getSettingAsInt(getSettingName("concurrencyLevel"), 5);
        this.hashing = ResourceHashing.fromName(searchEngine.getSettings().getSetting(getSettingName("hashing"), "uid"));
        this.backlog = searchEngine.getSettings().getSettingAsInt(getSettingName("backlog"), 100);
        this.addTimeout = searchEngine.getSettings().getSettingAsTimeInMillis(getSettingName("addTimeout"), 10000);
    }

    /**
     * Returns <code>true</code> if concurrent operaetions are enabled for this transaction processor.
     */
    public boolean isConcurrentOperations() {
        return concurrentOperations;
    }

    public void begin() throws SearchEngineException {
        // nothing to do here
    }

    public void prepare() throws SearchEngineException {
        if (concurrentOperations) {
            waitForJobs();
        }
        doPrepare();
    }

    /**
     * Base classes should implement this. Behaviour should be the same as {@link #prepare()}.
     */
    protected abstract void doPrepare() throws SearchEngineException;

    public void commit(boolean onePhase) throws SearchEngineException {
        if (concurrentOperations) {
            waitForJobs();
        }
        doCommit(onePhase);
    }

    /**
     * Base classes should implement this. Behaviour should be the same as {@link #commit(boolean)}.
     */
    protected abstract void doCommit(boolean onePhase) throws SearchEngineException;

    public void rollback() throws SearchEngineException {
        clearJobs();
        doRollback();
    }

    /**
     * Base classes should implement this. Behaviour should be the same as {@link #rollback()}.
     */
    protected abstract void doRollback() throws SearchEngineException;

    public void flush() throws SearchEngineException {
        waitForJobs();
        doFlush();
    }

    protected void doFlush() throws SearchEngineException {

    }

    public void create(InternalResource resource) throws SearchEngineException {
        if (concurrentOperations) {
            TransactionJob job = new TransactionJob(TransactionJob.Type.CREATE, resource);
            prepareBeforeAsyncDirtyOperation(job);
            getProcessor(job).addJob(job);
        } else {
            doCreate(resource);
        }
    }

    /**
     * Base classes should implement this. Behaviour should be the same as {@link #create(org.compass.core.spi.InternalResource)}.
     */
    protected abstract void doCreate(InternalResource resource) throws SearchEngineException;

    public void update(InternalResource resource) throws SearchEngineException {
        if (concurrentOperations) {
            TransactionJob job = new TransactionJob(TransactionJob.Type.UPDATE, resource);
            prepareBeforeAsyncDirtyOperation(job);
            getProcessor(job).addJob(job);
        } else {
            doUpdate(resource);
        }
    }

    /**
     * Base classes should implement this. Behaviour should be the same as {@link #update(org.compass.core.spi.InternalResource)}.
     */
    protected abstract void doUpdate(InternalResource resource) throws SearchEngineException;

    public void delete(ResourceKey resourceKey) throws SearchEngineException {
        if (concurrentOperations) {
            TransactionJob job = new TransactionJob(TransactionJob.Type.DELETE, resourceKey);
            prepareBeforeAsyncDirtyOperation(job);
            getProcessor(job).addJob(job);
        } else {
            doDelete(resourceKey);
        }
    }

    /**
     * Base classes should implement this. Behaviour should be the same as {@link #delete(org.compass.core.spi.ResourceKey)}.
     */
    protected abstract void doDelete(ResourceKey resourceKey) throws SearchEngineException;

    /**
     * Called by a single thread (the calling thread) before a dirty transaction job is added to the
     * queue to be executed in an async manner.
     */
    protected abstract void prepareBeforeAsyncDirtyOperation(TransactionJob job) throws SearchEngineException;

    public LuceneSearchEngineHits find(LuceneSearchEngineQuery query) throws SearchEngineException {
        if (waitForSearchOperations && concurrentOperations) {
            waitForJobs();
        }
        return doFind(query);
    }

    /**
     * Base classes should implement this. Behaviour should be the same as {@link #find(org.compass.core.lucene.engine.LuceneSearchEngineQuery)}.
     */
    protected abstract LuceneSearchEngineHits doFind(LuceneSearchEngineQuery query) throws SearchEngineException;

    public LuceneSearchEngineInternalSearch internalSearch(String[] subIndexes, String[] aliases) throws SearchEngineException {
        if (waitForSearchOperations && concurrentOperations) {
            waitForJobs();
        }
        return doInternalSearch(subIndexes, aliases);
    }

    /**
     * Base classes should implement this. Behaviour should be the same as {@link #internalSearch(String[], String[])}.
     */
    protected abstract LuceneSearchEngineInternalSearch doInternalSearch(String[] subIndexes, String[] aliases) throws SearchEngineException;

    public Resource[] get(ResourceKey resourceKey) throws SearchEngineException {
        if (waitForSearchOperations && concurrentOperations) {
            waitForJobs();
        }
        return doGet(resourceKey);
    }

    /**
     * Base classes should implement this. Behaviour should be the same as {@link #get(org.compass.core.spi.ResourceKey)}.
     */
    protected abstract Resource[] doGet(ResourceKey resourceKey) throws SearchEngineException;

    /**
     * Similar to {@link #waitForJobs()} except that it clears all the remaining jobs from execution and simply
     * waits for clean stop of the processors. Does not throw any processing exceptions, instead logs them since
     * this is usually called by {@link #rollback()}.
     */
    private void clearJobs() {
        if (!concurrentOperations || processors == null) {
            return;
        }
        InterruptedException ie = null;
        int lastId = -1;
        for (Processor processor : processors) {
            if (processor != null) {
                // we clean before stop so we won't even process any remaining jobs
                processor.clear();
                try {
                    processor.stop();
                } catch (InterruptedException e) {
                    lastId = processor.getId();
                    ie = e;
                }
            }
        }
        if (ie != null) {
            logger.warn("Failed to wait for processor [" + lastId + "] to stop, interrupted", ie);
        }
        SearchEngineException exception = null;
        for (Processor processor : processors) {
            if (processor != null) {
                try {
                    processor.waitTillStopped();
                } catch (InterruptedException e) {
                    throw new SearchEngineException("Failed to wait for processor [" + processor.getId() + "] to be stopped / process all jobs", e);
                }
                exception = processor.getException();
            }
        }
        if (exception != null) {
            logger.trace("EXception while waiting to clear jobs for rollback", exception);
        }
    }

    /**
     * Waits for all the current dirty operations (if there are any) to be performed. Stops all the processors
     * as well.
     *
     * <p>If there were any exceptions during the processing of dirty operation by any processor, they will be
     * thrown.
     */
    private void waitForJobs() throws SearchEngineException {
        if (!concurrentOperations || processors == null) {
            return;
        }
        InterruptedException ie = null;
        int lastId = -1;
        for (Processor processor : processors) {
            if (processor != null) {
                try {
                    processor.stop();
                } catch (InterruptedException e) {
                    lastId = processor.getId();
                    ie = e;
                }
            }
        }
        if (ie != null) {
            logger.warn("Failed to wait for processor [" + lastId + "] to stop, interrupted", ie);
        }
        SearchEngineException exception = null;
        for (Processor processor : processors) {
            if (processor != null) {
                try {
                    processor.waitTillStopped();
                } catch (InterruptedException e) {
                    throw new SearchEngineException("Failed to wait for processor [" + processor.getId() + "] to be stopped / process all jobs", e);
                }
                exception = processor.getException();
            }
        }
        if (exception != null) {
            throw exception;
        }
    }

    /**
     * Returns the processor that should handle the specific {@link org.compass.core.lucene.engine.transaction.support.TransactionJob}.
     * If the processor has not been created, it will be lazily created. If the processor has not been scheduled yet
     * to a thread, it will also be scheduled to one.
     */
    private Processor getProcessor(TransactionJob job) {
        if (processors == null) {
            processors = new Processor[concurrencyLevel];
        }
        int processorIndex = hashing.hash(job) % concurrencyLevel;
        Processor processor = processors[processorIndex];
        if (processor == null) {
            processor = new Processor(processorIndex);
            processors[processorIndex] = processor;
        }
        try {
            if (processor.needsReschedule()) {
                processor.start();
            }
        } catch (InterruptedException e) {
            throw new SearchEngineException("Failed to wait for processor [" + processor.getId() + "] to check if stopped", e);
        }

        return processor;
    }

    /**
     * Processor attached to a thread and responsible for processing dirty operations assigned to it.
     */
    private class Processor implements Runnable {

        private final BlockingQueue<TransactionJob> jobs = new ArrayBlockingQueue<TransactionJob>(backlog);

        private final int id;

        private volatile boolean stopped = true;

        private volatile CountDownLatch stopLatch;

        private volatile CountDownLatch startLatch;

        private volatile SearchEngineException exception;

        private Processor(int id) {
            this.id = id;
        }

        /**
         * Returns the id of the processor.
         */
        public int getId() {
            return id;
        }

        /**
         * Returns an exception that happened during an execution of the processor.
         *
         * <p>Note, should be called after {@link #waitTillStopped()}.
         */
        public SearchEngineException getException() {
            return exception;
        }

        /**
         * Returns <code>true</code> if the processor requires rescheduling to a thread.
         */
        public boolean needsReschedule() throws InterruptedException {
            if (stopped) {
                waitTillStopped();
            }
            return stopped;
        }

        /**
         * Starts the given processor, scheduling it to a thread as well.
         */
        public void start() {
            if (logger.isTraceEnabled()) {
                logger.trace("Processor [" + id + "]: Starting");
            }
            startLatch = new CountDownLatch(1);
            stopped = false;
            indexManager.getExecutorManager().submit(this);
        }

        /**
         * Stops the given processor. Note, stopping the processor will cause it to finish executing all the remaining
         * jobs and then exiting.
         */
        public void stop() throws InterruptedException {
            if (stopped) {
                return;
            }
            if (logger.isTraceEnabled()) {
                logger.trace("Processor [" + id + "]: Stopping");
            }
            stopped = true;
        }

        /**
         * Clears the jobs associated with the processor.
         */
        public void clear() {
            jobs.clear();
        }

        /**
         * Wait till stop. Note, should be called only after {@link #stop()}  was called.
         */
        public void waitTillStopped() throws InterruptedException {
            if (startLatch != null) {
                startLatch.await();
            }
            if (stopLatch != null) {
                stopLatch.await();
            }
        }

        /**
         * Adds a job to the processor. If there is an execption that occured during the procesing of a previously
         * submitted job, the exception will be thrown.
         *
         * <p>If the backlog of the processor is full, will wait till space becomes avaialbe.
         */
        public void addJob(TransactionJob job) throws SearchEngineException {
            if (exception != null) {
                throw exception;
            }
            try {
                if (logger.isTraceEnabled()) {
                    logger.trace("Processor [" + id + "]: Adding Job [" + job + "]");
                }
                boolean offered = jobs.offer(job, addTimeout, TimeUnit.MILLISECONDS);
                if (!offered) {
                    throw new SearchEngineException("Processor [" + id + "]: Failed to add job [" + job + "] after [" + addTimeout + "ms] and backlog size [" + backlog + "]");
                }
            } catch (InterruptedException e) {
                throw new SearchEngineException("Processor [" + id + "]: Failed to add job [" + job + "], interrupted while adding to queue", e);
            }
        }

        public void run() {
            try {
                // clear the exception, since this is a new run
                // note, calling getException is only done after we waitTillStopped (which is only done after stop)
                exception = null;

                stopLatch = new CountDownLatch(1);
                startLatch.countDown();
                if (logger.isTraceEnabled()) {
                    logger.trace("Processor [" + id + "]: Started");
                }
                while (!stopped) {
                    TransactionJob job;
                    try {
                        job = jobs.poll(100, TimeUnit.MILLISECONDS);
                    } catch (InterruptedException e) {
                        if (!stopped) {
                            logger.warn("Processor [" + id + "]: Interrupted without being stopped", e);
                        }
                        break;
                    }
                    if (job != null) {
                        try {
                            processJob(job);
                        } catch (SearchEngineException e) {
                            exception = e;
                            break;
                        }
                    }
                }
                if (exception != null) {
                    if (logger.isTraceEnabled()) {
                        logger.trace("Processor [" + id + "]: Stopping because of an exception", exception);
                    }
                } else {
                    if (logger.isTraceEnabled()) {
                        logger.trace("Processor [" + id + "]: Received stop, processing remaining jobs");
                    }
                    try {
                        processRemainingJobs();
                    } catch (SearchEngineException e) {
                        if (logger.isTraceEnabled()) {
                            logger.trace("Processor [" + id + "]: Failed to processes remaining jobs", e);
                        }
                        exception = e;
                    }
                }
                if (logger.isTraceEnabled()) {
                    logger.trace("Processor [" + id + "]: Stopped");
                }
            } catch (Exception e) {
                logger.warn("Processor [" + id + "]: Recevied an unexpected exception", e);
            } finally {
                stopLatch.countDown();
            }
        }

        private void processRemainingJobs() throws SearchEngineException {
            ArrayList<TransactionJob> remainingJobs = new ArrayList<TransactionJob>();
            jobs.drainTo(remainingJobs);
            for (TransactionJob job : remainingJobs) {
                processJob(job);
            }
        }

        private void processJob(TransactionJob job) throws SearchEngineException {
            if (logger.isTraceEnabled()) {
                logger.trace("Processor [" + id + "]: Processing Job  [" + job + "]");
            }
            switch (job.getType()) {
                case CREATE:
                    doCreate(job.getResource());
                    break;
                case UPDATE:
                    doUpdate(job.getResource());
                    break;
                case DELETE:
                    doDelete(job.getResourceKey());
                    break;
            }
        }
    }
}