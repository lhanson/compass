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

package org.compass.core.test.nullvalue.global;

import org.compass.core.CompassSession;
import org.compass.core.CompassTransaction;
import org.compass.core.Resource;
import org.compass.core.config.CompassConfiguration;
import org.compass.core.config.CompassEnvironment;
import org.compass.core.test.AbstractTestCase;

/**
 * @author kimchy
 */
public class GlobalNullValueTests extends AbstractTestCase {

    protected String[] getMappings() {
        return new String[]{"nullvalue/global/mapping.cpm.xml"};
    }

    protected void addExtraConf(CompassConfiguration conf) {
        conf.setSetting(CompassEnvironment.NullValue.NULL_VALUE, "koo");
    }

    public void testGlobalNullValueSettingsAllNulls() throws Exception {
        CompassSession session = openSession();
        CompassTransaction tr = session.beginTransaction();

        A a = new A();
        a.id = 1;
        session.save("a", a);

        a = (A) session.load("a", 1);
        assertNull(a.value1);
        assertNull(a.value2);
        assertNull(a.value3);

        Resource resource = session.loadResource("a", 1);
        // value1 uses the global setting
        assertEquals("koo", resource.getValue("value1"));
        // value2 defines his own
        assertEquals("moo", resource.getValue("value2"));
        // value3 defines $disable$ which means it needs to be disabled
        assertNull(resource.getValue("value3"));

        tr.commit();
        session.close();
    }
}