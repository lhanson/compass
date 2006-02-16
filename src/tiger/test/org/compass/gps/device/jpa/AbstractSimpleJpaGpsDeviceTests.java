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

package org.compass.gps.device.jpa;

import org.compass.core.CompassHits;
import org.compass.core.CompassSession;
import org.compass.core.CompassTransaction;
import org.compass.core.config.CompassConfiguration;
import org.compass.gps.device.jpa.model.Simple;
import org.compass.gps.device.jpa.model.SimpleBase;
import org.compass.gps.device.jpa.model.SimpleExtend;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;

/**
 * @author kimchy
 */
public abstract class AbstractSimpleJpaGpsDeviceTests extends AbstractJpaGpsDeviceTests {

    protected void setUpCoreCompass(CompassConfiguration conf) {
        conf.addClass(Simple.class).addClass(SimpleBase.class).addClass(SimpleExtend.class);
    }

    @Override
    protected void setUpDB(EntityManager entityManager) {
        Simple simple = new Simple();
        simple.setId(1);
        simple.setValue("value1");
        entityManager.persist(simple);
        simple = new Simple();
        simple.setId(2);
        simple.setValue("value2");
        entityManager.persist(simple);
        simple = new Simple();
        simple.setId(3);
        simple.setValue("value3");
        entityManager.persist(simple);

        SimpleBase simpleBase = new SimpleBase();
        simpleBase.setId(1);
        simpleBase.setValue("value");
        entityManager.persist(simpleBase);

        SimpleExtend simpleExtend = new SimpleExtend();
        simpleExtend.setId(2);
        simpleExtend.setValue("value");
        simpleExtend.setValueExtend("valueExtended");
        entityManager.persist(simpleExtend);
    }

    @Override
    protected void tearDownDB(EntityManager entityManager) {
        Query query = entityManager.createQuery("delete from Simple");
        query.executeUpdate();
    }

    public void testSimple() throws Exception {
        compassGps.index();

        CompassSession sess = compass.openSession();
        CompassTransaction tr = sess.beginTransaction();

        Simple simple = (Simple) sess.load(Simple.class, 1);
        assertEquals("value1", simple.getValue());
        simple = (Simple) sess.load(Simple.class, 2);
        assertEquals("value2", simple.getValue());

        tr.commit();
        sess.close();
    }

    public void testMirror() throws Exception {
        compassGps.index();

        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction entityTransaction = entityManager.getTransaction();
        entityTransaction.begin();

        // insert a new one
        Simple simple = new Simple();
        simple.setId(4);
        simple.setValue("value4");
        entityManager.persist(simple);

        // delete the second one
        simple = entityManager.find(Simple.class, 2);
        entityManager.remove(simple);

        // update the first one
        simple = entityManager.find(Simple.class, 1);
        simple.setValue("updatedValue1");
        entityManager.persist(simple);

        entityManager.flush();

        entityTransaction.commit();
        entityManager.close();

        CompassSession sess = compass.openSession();
        CompassTransaction tr = sess.beginTransaction();

        simple = (Simple) sess.load(Simple.class, 4);
        assertEquals("value4", simple.getValue());

        simple = (Simple) sess.get(Simple.class, 2);
        assertNull(simple);

        simple = (Simple) sess.load(Simple.class, 1);
        assertEquals("updatedValue1", simple.getValue());

        tr.commit();
        sess.close();
    }

    public void testExtend() throws Exception {
        compassGps.index();

        CompassSession sess = compass.openSession();
        CompassTransaction tr = sess.beginTransaction();

        SimpleBase simpleBase = (SimpleBase) sess.load(SimpleBase.class, 1);
        assertEquals("value", simpleBase.getValue());
        SimpleExtend simpleExtend = (SimpleExtend) sess.load(SimpleExtend.class, 2);
        assertEquals("value", simpleExtend.getValue());
        assertEquals("valueExtended", simpleExtend.getValueExtend());

        CompassHits hits = sess.queryBuilder()
                .queryString("value").toQuery()
                .setSubIndexes(new String[] {"simple1"})
                .hits();
        assertEquals(2, hits.length());


        tr.commit();
        sess.close();
    }

}
