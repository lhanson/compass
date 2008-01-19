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

package org.compass.core.transaction;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.compass.core.Compass;
import org.compass.core.config.CompassEnvironment;
import org.compass.core.config.CompassSettings;
import org.compass.core.config.ConfigurationException;
import org.compass.core.util.ClassUtils;

/**
 * @author kimchy
 */
public class TransactionFactoryFactory {

    private static final Log log = LogFactory.getLog(TransactionFactoryFactory.class);

    public static TransactionFactory createTransactionFactory(Compass compass, CompassSettings settings) {
        String factoryClassName = settings.getSetting(CompassEnvironment.Transaction.FACTORY,
                LocalTransactionFactory.class.getName());
        return createTransactionFactory(compass, factoryClassName, settings);
    }

    public static LocalTransactionFactory createLocalTransactionFactory(Compass compass, CompassSettings settings) {
        return (LocalTransactionFactory) createTransactionFactory(compass, LocalTransactionFactory.class.getName(), settings);
    }

    public static TransactionFactory createTransactionFactory(Compass compass, String factoryClassName, CompassSettings settings) {

        if (log.isDebugEnabled()) {
            log.debug("Using transaction factory [" + factoryClassName + "]");
        }

        try {
            TransactionFactory factory = (TransactionFactory) ClassUtils.forName(factoryClassName, settings.getClassLoader()).newInstance();
            factory.configure(compass, settings);
            return factory;
        } catch (Exception e) {
            throw new ConfigurationException("Failed to create transaction factory class [" + factoryClassName + "]", e);
        }
    }
}
