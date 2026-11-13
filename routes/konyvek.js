import pool from "../data/db.js";
import { Router } from "express";

const router = Router()

router.get('/elerheto', async (req, res) => {

    const sql = `
        SELECT *
        FROM konyvek k
        WHERE NOT EXISTS (
            SELECT 1
            FROM kolcsonzesek ko
            WHERE ko.konyvId = k.id
            AND ko.visszahozva = 'false'
        )
    `;

    const [eredmeny] = await pool.query(sql);

    res.json(eredmeny);
});

export default router