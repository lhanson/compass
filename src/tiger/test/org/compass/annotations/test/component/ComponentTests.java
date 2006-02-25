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

package org.compass.annotations.test.component;

import java.util.ArrayList;
import java.util.HashSet;

import org.compass.annotations.test.AbstractAnnotationsTestCase;
import org.compass.core.*;
import org.compass.core.config.CompassConfiguration;

/**
 * @author kimchy
 */
public class ComponentTests extends AbstractAnnotationsTestCase {

    protected void addExtraConf(CompassConfiguration conf) {
        conf.addClass(A.class).addClass(B.class);
    }

    public void testSimpleComponent() {
        CompassSession session = openSession();
        CompassTransaction tr = session.beginTransaction();

        A a = new A();
        a.id = 1;
        a.value = "avalue";

        B b = new B();
        b.value = "bvalue";
        a.b = b;

        ArrayList<B> bValues = new ArrayList<B>();
        bValues.add(new B("bvalue1"));
        bValues.add(new B("bvalue2"));
        a.bValues = bValues;

        HashSet<B> bValuesSet = new HashSet<B>();
        bValuesSet.add(new B("bvalueset1"));
        bValuesSet.add(new B("bvalueset2"));
        a.bValuesSet = bValuesSet;

        session.save(a);

        a = (A) session.load(A.class, 1);
        assertEquals("avalue", a.value);
        assertEquals("bvalue", a.b.value);
        assertEquals("bvalue1", a.bValues.get(0).value);
        assertEquals("bvalue2", a.bValues.get(1).value);
        assertEquals(2, a.bValuesSet.size());

        CompassHits hits = session.find("bvalue");
        assertEquals(1, hits.length());
        a = (A) hits.data(0);
        assertEquals("avalue", a.value);
        assertEquals("bvalue", a.b.value);

        hits = session.find("bValue:bvalueset1");
        assertEquals(1, hits.length());
        a = (A) hits.data(0);
        assertEquals("avalue", a.value);
        assertEquals("bvalue", a.b.value);

        Resource resource = hits.resource(0);
        assertEquals(5, resource.getProperties("bValue").length);

        hits = session.find("bValue:bvalueset2");
        assertEquals(1, hits.length());
        a = (A) hits.data(0);
        assertEquals("avalue", a.value);
        assertEquals("bvalue", a.b.value);

        hits = session.find("bvalue1");
        assertEquals(1, hits.length());

        // this only works because B value is defined with ManageIdIndex.UN_TOKENIZED
        CompassQuery query = session.queryBuilder().term("A.bValues.value", "bvalue1");
        hits = query.hits();
        assertEquals(1, hits.length());

        query = session.queryBuilder().term("A.bValues.value", "bvalue1");
        hits = query.setAliases(new String[] {"A"}).hits();
        assertEquals(1, hits.length());

        tr.commit();
        session.close();
    }

}
